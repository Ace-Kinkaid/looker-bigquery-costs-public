project_name: "bq_cost_attribution"

# =================================================================================================
# PROJECT CONFIGURATION CONSTANTS (ONE-STOP LOOKML CONFIGURATION)
# =================================================================================================
# Update these 4 values with your actual Google Cloud & Looker environment details.
# These constants are automatically referenced across all LookML models, views, and derived tables.
# Once updated here, the entire LookML project automatically points to your environment!
# =================================================================================================

# 1. Looker Database Connection Name (configured in Looker Admin > Connections)
constant: CONNECTION_NAME {
  value: "my_awesome_bq_connection"
  export: override_optional
}

# 2. Google Cloud Project ID where BigQuery queries execute and dataset resides
constant: GCP_PROJECT_ID {
  value: "my-awesome-gcp-project"
  export: override_optional
}

# 3. BigQuery Region Qualifier for INFORMATION_SCHEMA (e.g. region-us, region-eu, region-us-central1)
constant: BQ_REGION {
  value: "region-us"
  export: override_optional
}

# 4. BigQuery Dataset ID where Looker System Activity tables (users, history) are loaded
constant: BQ_DATASET_NAME {
  value: "looker_bq_costs"
  export: override_optional
}
