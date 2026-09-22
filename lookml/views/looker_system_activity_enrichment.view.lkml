# =================================================================================================
# LOOKER SYSTEM ACTIVITY ENRICHMENT VIEW
# =================================================================================================
# View Name: looker_system_activity_enrichment
# Description:
#   Auxiliary enrichment view for mapping Looker user group hierarchies, departments, user roles,
#   and folder/space metadata to BigQuery query execution records.
# =================================================================================================

view: looker_system_activity_enrichment {
  dimension: history_slug {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.history_slug ;;
    description: "Unique history slug linking to BigQuery job records"
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
    description: "Looker User ID"
  }

  dimension: user_group {
    type: string
    sql: COALESCE(${TABLE}.user_group, 'General Users') ;;
    label: "User Group"
    description: "Looker User Group for organizational chargeback attribution"
  }

  dimension: department {
    type: string
    sql: COALESCE(${TABLE}.department, 'Unassigned') ;;
    label: "Department"
    description: "Business department associated with the querying user"
  }

  dimension: user_role {
    type: string
    sql: COALESCE(${TABLE}.user_role, 'Standard User') ;;
    label: "User Role"
    description: "Permission role assigned to the querying user (e.g., Admin, Developer, Viewer)"
  }

  dimension: folder_name {
    type: string
    sql: COALESCE(${TABLE}.folder_name, 'Shared / System') ;;
    label: "Folder Name"
    description: "Folder or Space location containing the content asset"
  }
}
