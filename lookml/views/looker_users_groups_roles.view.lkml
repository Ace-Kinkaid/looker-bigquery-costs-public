view: looker_users_groups_roles {
  sql_table_name: `@{GCP_PROJECT_ID}.@{BQ_DATASET_NAME}.users_groups_roles` ;;

  dimension: compound_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.user_id AS STRING), '_', COALESCE(CAST(${TABLE}.group_id AS STRING), '0'), '_', COALESCE(CAST(${TABLE}.role_id AS STRING), '0')) ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_name {
    type: string
    hidden: yes
    sql: ${TABLE}.user_name ;;
  }

  dimension: group_id {
    type: number
    sql: ${TABLE}.group_id ;;
    label: "Group ID"
  }

  dimension: group_name {
    type: string
    sql: COALESCE(${TABLE}.group_name, 'Unassigned / Direct') ;;
    label: "Looker Group"
    description: "Looker User Group"
    suggest_persist_for: "0 seconds"
  }

  dimension: role_id {
    type: number
    sql: ${TABLE}.role_id ;;
    label: "Role ID"
  }

  dimension: role_name {
    type: string
    sql: COALESCE(${TABLE}.role_name, 'Unassigned Role') ;;
    label: "Looker Role"
    description: "Looker Role assigned to user or group"
    suggest_persist_for: "0 seconds"
  }

  measure: group_count {
    type: count_distinct
    sql: ${TABLE}.group_id ;;
    label: "Distinct Groups Count"
  }

  measure: role_count {
    type: count_distinct
    sql: ${TABLE}.role_id ;;
    label: "Distinct Roles Count"
  }
}
