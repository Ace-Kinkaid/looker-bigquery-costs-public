import os
import functions_framework
from google.cloud import bigquery

PROJECT_ID = os.environ.get("GCP_PROJECT", "YOUR_PROJECT_ID")
DATASET_ID = os.environ.get("BQ_DATASET", "looker_bq_costs")

bq_client = bigquery.Client(project=PROJECT_ID)

@functions_framework.cloud_event
def gcs_to_bigquery_loader(cloud_event):
    """Triggered by GCS object finalization (new CSV uploaded)."""
    data = cloud_event.data
    bucket_name = data["bucket"]
    file_name = data["name"]

    # Only process CSV files inside system_activity_reports/
    if not file_name.endswith(".csv"):
        print(f"Skipping non-CSV file: {file_name}")
        return

    gcs_uri = f"gs://{bucket_name}/{file_name}"
    print(f"Processing event for file: {gcs_uri}")

    if "users_groups_roles" in file_name:
        load_users_groups_roles(gcs_uri)
    elif "users" in file_name:
        load_users(gcs_uri)
    elif "history" in file_name:
        load_history_incremental(gcs_uri)
    else:
        print(f"Ignored unmatched CSV file: {file_name}")

def load_users(gcs_uri: str):
    """Full atomic overwrite for Users dimension table."""
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.users"
    job_config = bigquery.LoadJobConfig(
        schema=[
            bigquery.SchemaField("user_id", "INT64"),
            bigquery.SchemaField("user_name", "STRING"),
            bigquery.SchemaField("user_email", "STRING"),
        ],
        skip_leading_rows=1,
        source_format=bigquery.SourceFormat.CSV,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
    )
    load_job = bq_client.load_table_from_uri(gcs_uri, table_ref, job_config=job_config)
    load_job.result()
    print(f"Successfully loaded {load_job.output_rows} rows into {table_ref}")

def load_users_groups_roles(gcs_uri: str):
    """Full atomic overwrite for User Groups & Roles bridge table, filtering out auto-generated self-service roles."""
    staging_table = f"{PROJECT_ID}.{DATASET_ID}.users_groups_roles_staging"
    target_table = f"{PROJECT_ID}.{DATASET_ID}.users_groups_roles"
    job_config = bigquery.LoadJobConfig(
        schema=[
            bigquery.SchemaField("user_id", "INT64"),
            bigquery.SchemaField("user_name", "STRING"),
            bigquery.SchemaField("role_id", "INT64"),
            bigquery.SchemaField("role_name", "STRING"),
            bigquery.SchemaField("group_id", "INT64"),
            bigquery.SchemaField("group_name", "STRING"),
        ],
        skip_leading_rows=1,
        source_format=bigquery.SourceFormat.CSV,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
    )
    load_job = bq_client.load_table_from_uri(gcs_uri, staging_table, job_config=job_config)
    load_job.result()
    print(f"Staged {load_job.output_rows} rows into {staging_table}")

    # Atomic overwrite into target table filtering out auto-generated self_service roles
    filter_query = f"""
    CREATE OR REPLACE TABLE `{target_table}` AS
    SELECT DISTINCT
        user_id,
        user_name,
        role_id,
        role_name,
        group_id,
        group_name
    FROM `{staging_table}`
    WHERE role_name IS NULL OR role_name NOT LIKE 'self_service__%'
    """
    query_job = bq_client.query(filter_query)
    query_job.result()
    print(f"Successfully filtered and populated {target_table}")

def load_history_incremental(gcs_uri: str):
    """Loads history to staging and performs an idempotent MERGE into the partitioned history table."""
    staging_table = f"{PROJECT_ID}.{DATASET_ID}.history_staging"
    target_table = f"{PROJECT_ID}.{DATASET_ID}.history"

    job_config = bigquery.LoadJobConfig(
        schema=[
            bigquery.SchemaField("history_id", "INT64"),
            bigquery.SchemaField("created_at", "TIMESTAMP"),
            bigquery.SchemaField("query_id", "INT64"),
            bigquery.SchemaField("dashboard_id", "STRING"),
            bigquery.SchemaField("dashboard_title", "STRING"),
            bigquery.SchemaField("query_explore", "STRING"),
            bigquery.SchemaField("query_model", "STRING"),
            bigquery.SchemaField("user_id", "INT64"),
            bigquery.SchemaField("history_slug", "STRING"),
            bigquery.SchemaField("source", "STRING"),
            bigquery.SchemaField("api_client_name", "STRING"),
            bigquery.SchemaField("agent_name", "STRING"),
            bigquery.SchemaField("ca_agent_id", "STRING"),
            bigquery.SchemaField("ca_conversation_id", "STRING"),
        ],
        skip_leading_rows=1,
        source_format=bigquery.SourceFormat.CSV,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
    )
    load_job = bq_client.load_table_from_uri(gcs_uri, staging_table, job_config=job_config)
    load_job.result()
    print(f"Staged {load_job.output_rows} rows into {staging_table}")

    merge_sql = f"""
    MERGE `{target_table}` T
    USING `{staging_table}` S
    ON T.history_id = S.history_id
       AND T.created_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
    WHEN MATCHED THEN
      UPDATE SET
        created_at = S.created_at,
        query_id = S.query_id,
        dashboard_id = S.dashboard_id,
        dashboard_title = S.dashboard_title,
        query_explore = S.query_explore,
        query_model = S.query_model,
        user_id = S.user_id,
        history_slug = S.history_slug,
        source = S.source,
        api_client_name = S.api_client_name,
        agent_name = S.agent_name,
        ca_agent_id = S.ca_agent_id,
        ca_conversation_id = S.ca_conversation_id
    WHEN NOT MATCHED THEN
      INSERT (
        history_id, created_at, query_id, dashboard_id, dashboard_title,
        query_explore, query_model, user_id, history_slug,
        source, api_client_name, agent_name, ca_agent_id, ca_conversation_id
      )
      VALUES (
        S.history_id, S.created_at, S.query_id, S.dashboard_id, S.dashboard_title,
        S.query_explore, S.query_model, S.user_id, S.history_slug,
        S.source, S.api_client_name, S.agent_name, S.ca_agent_id, S.ca_conversation_id
      );
    """
    query_job = bq_client.query(merge_sql)
    query_job.result()
    print(f"Successfully merged new history records into {target_table}")
