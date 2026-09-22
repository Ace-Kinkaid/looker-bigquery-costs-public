-- =================================================================================================
-- USERS DIMENSION TABLE DDL
-- Replace `YOUR_PROJECT_ID.YOUR_DATASET_ID` with your target GCP Project and BigQuery Dataset.
-- =================================================================================================

CREATE OR REPLACE TABLE `YOUR_PROJECT_ID.YOUR_DATASET_ID.users`
(
  user_id INT64 OPTIONS(description="Unique Looker internal User ID"),
  user_name STRING OPTIONS(description="Full name of the Looker user"),
  user_email STRING OPTIONS(description="Corporate email address of the Looker user")
)
CLUSTER BY user_id
OPTIONS(
  description="Looker User Directory metadata for cost governance chargeback",
  labels=[("data_domain", "cost_governance"), ("source", "looker_system_activity")]
);
