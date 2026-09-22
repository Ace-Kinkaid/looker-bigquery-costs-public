# =================================================================================================
# LOOKER & BIGQUERY COST GOVERNANCE & ATTRIBUTION MODEL
# =================================================================================================
# Model Name: bq_cost_attribution
# Connection: sample_retail_data
# Description:
#   Central data model defining the Looker & BigQuery Cost Governance explore, datagroups,
#   caching policies, and user group join relationships.
# =================================================================================================

connection: "@{CONNECTION_NAME}"

include: "/views/**/*.view.lkml"
include: "/dashboards/**/*.dashboard.lookml"

# -------------------------------------------------------------------------------------------------
# DATAGROUP: 24-Hour Persistence Schedule at 6:00 AM ET (America/New_York)
# Aligns PDT rebuild with the daily Looker System Activity GCS export delivery window.
# -------------------------------------------------------------------------------------------------
datagroup: bq_cost_attribution_daily_6am {
  max_cache_age: "24 hours"
  sql_trigger: SELECT CAST(TIMESTAMP_TRUNC(TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 6 HOUR), DAY, 'America/New_York') AS STRING) ;;
  description: "Triggers PDT rebuild every 24 hours at 6:00 AM ET (America/New_York)"
}

persist_with: bq_cost_attribution_daily_6am

# -------------------------------------------------------------------------------------------------
# EXPLORE: looker_cost_analytics
# Main analytics explore powering the 4-tab Cost Governance Dashboard.
# -------------------------------------------------------------------------------------------------
explore: looker_cost_analytics {
  label: "Looker & BigQuery Cost Analytics"
  description: "Comprehensive BigQuery query execution, scan cost, and Looker user chargeback attribution"
  view_name: bigquery_looker_jobs

  # Default to last 30 days to optimize initial dashboard query latency and cost
  always_filter: {
    filters: [bigquery_looker_jobs.query_time_date: "30 days"]
  }

  # Join user groups and roles for department-level chargeback rollups
  join: looker_users_groups_roles {
    type: left_outer
    relationship: many_to_many
    sql_on: ${bigquery_looker_jobs.looker_user_id} = ${looker_users_groups_roles.user_id} ;;
  }
}
