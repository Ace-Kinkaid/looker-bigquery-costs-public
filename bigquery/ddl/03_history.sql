-- =================================================================================================
-- LOOKER SYSTEM ACTIVITY QUERY HISTORY TABLE DDL
-- Replace `my-awesome-gcp-project.looker_bq_costs` with your `<PROJECT_ID>.<DATASET_ID>`.
-- =================================================================================================

CREATE OR REPLACE TABLE `my-awesome-gcp-project.looker_bq_costs.history`
(
  history_id INT64 OPTIONS(description="Unique execution ID from Looker System Activity history"),
  created_at TIMESTAMP OPTIONS(description="Timestamp when Looker initiated the query"),
  query_id INT64 OPTIONS(description="Looker Query Definition ID"),
  dashboard_id STRING OPTIONS(description="User-defined or LookML dashboard identifier"),
  dashboard_title STRING OPTIONS(description="Dashboard title at query runtime"),
  query_explore STRING OPTIONS(description="Target Explore name"),
  query_model STRING OPTIONS(description="Target Model name"),
  user_id INT64 OPTIONS(description="Executing Looker User ID"),
  history_slug STRING OPTIONS(description="Unique 8-character slug matching BigQuery comment context"),
  source STRING OPTIONS(description="Looker query source (api4, dashboard, explore, regenerator, look, alert, etc.)"),
  api_client_name STRING OPTIONS(description="API client application name (e.g. Conversational Analytics, MCP Toolbox, Connected Sheets)"),
  agent_name STRING OPTIONS(description="Conversational Analytics agent name"),
  ca_agent_id STRING OPTIONS(description="Conversational Analytics agent UUID"),
  ca_conversation_id STRING OPTIONS(description="Conversational Analytics conversation session UUID")
)
PARTITION BY DATE(created_at)
CLUSTER BY history_slug, query_id, user_id
OPTIONS(
  partition_expiration_days=365,
  description="Looker System Activity query history audit log with Conversational Analytics attribution",
  labels=[("data_domain", "cost_governance"), ("source", "looker_system_activity")]
);
