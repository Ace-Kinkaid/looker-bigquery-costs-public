-- =================================================================================================
-- USERS-GROUPS-ROLES BRIDGE TABLE DDL
-- Replace `my-awesome-gcp-project.looker_bq_costs` with your `<PROJECT_ID>.<DATASET_ID>`.
-- =================================================================================================

CREATE OR REPLACE TABLE `my-awesome-gcp-project.looker_bq_costs.users_groups_roles`
(
  user_id INT64 OPTIONS(description="Unique Looker internal User ID"),
  user_name STRING OPTIONS(description="Full name of the Looker user"),
  role_id INT64 OPTIONS(description="Looker Role ID"),
  role_name STRING OPTIONS(description="Assigned Looker Role (e.g. Admin, Developer, User)"),
  group_id INT64 OPTIONS(description="Looker Group ID"),
  group_name STRING OPTIONS(description="Looker Group Name (e.g. Sales-Analytics, Marketing)")
)
CLUSTER BY user_id, group_name
OPTIONS(
  description="Looker User-Group-Role membership mapping table",
  labels=[("data_domain", "cost_governance"), ("source", "looker_system_activity")]
);
