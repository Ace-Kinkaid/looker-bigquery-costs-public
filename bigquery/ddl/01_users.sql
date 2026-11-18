-- =================================================================================================
-- USERS DIMENSION TABLE DDL
-- Replace `my-awesome-gcp-project.looker_bq_costs` with your `<PROJECT_ID>.<DATASET_ID>`.
-- =================================================================================================

CREATE OR REPLACE TABLE `my-awesome-gcp-project.looker_bq_costs.users`
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
