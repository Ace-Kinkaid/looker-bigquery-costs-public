project_name: "bq_cost_attribution"

# =================================================================================================
# PROJECT CONFIGURATION CONSTANTS
# =================================================================================================
# Set your environment-specific configuration values here.
# These constants are automatically referenced across LookML models, views, and derived tables.
# =================================================================================================

constant: CONNECTION_NAME {
  value: "your_bigquery_connection"
  export: override_optional
}

constant: GCP_PROJECT_ID {
  value: "your-gcp-project-id"
  export: override_optional
}

constant: BQ_REGION {
  value: "us"
  export: override_optional
}

constant: BQ_DATASET_NAME {
  value: "looker_bq_costs"
  export: override_optional
}
