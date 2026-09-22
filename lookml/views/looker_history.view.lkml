view: looker_history {
  sql_table_name: `@{GCP_PROJECT_ID}.@{BQ_DATASET_NAME}.history` ;;

  dimension: history_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.history_id ;;
    label: "History ID"
    description: "Unique execution identifier from Looker System Activity"
  }

  dimension_group: created_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
    label: "Execution Created"
  }

  dimension: query_id {
    type: number
    sql: ${TABLE}.query_id ;;
    label: "Query ID"
  }

  dimension: dashboard_id {
    type: string
    sql: CAST(${TABLE}.dashboard_id AS STRING) ;;
    label: "Dashboard ID"
    description: "User-defined or LookML dashboard identifier"
  }

  dimension: dashboard_title {
    type: string
    sql: ${TABLE}.dashboard_title ;;
    label: "Dashboard Title"
  }

  dimension: query_explore {
    type: string
    sql: ${TABLE}.query_explore ;;
    label: "Query Explore"
  }

  dimension: query_model {
    type: string
    sql: ${TABLE}.query_model ;;
    label: "Query Model"
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    label: "User ID"
  }

  dimension: history_slug {
    type: string
    sql: ${TABLE}.history_slug ;;
    label: "History Slug"
    description: "Unique token matching BigQuery job metadata"
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
    label: "History Source"
    description: "Source identifier from Looker System Activity (e.g., api4, dashboard, explore, scheduled_task)"
  }

  dimension: api_client_name {
    type: string
    sql: ${TABLE}.api_client_name ;;
    label: "API Client Application"
    description: "API Client Application name (e.g., Conversational Analytics)"
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
    label: "Conversational Agent Name"
    description: "Name of the Conversational Analytics Agent"
  }

  dimension: ca_agent_id {
    type: string
    sql: ${TABLE}.ca_agent_id ;;
    label: "CA Agent ID"
    hidden: yes
  }

  dimension: ca_conversation_id {
    type: string
    sql: ${TABLE}.ca_conversation_id ;;
    label: "CA Conversation ID"
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: [history_id, dashboard_id, dashboard_title, query_explore, query_model, history_slug, agent_name, api_client_name]
  }
}
