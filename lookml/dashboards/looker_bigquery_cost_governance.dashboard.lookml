- dashboard: looker_bigquery_cost_governance
  title: "Looker & BigQuery Cost Governance"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive BigQuery scan cost attribution, user showback, group/role chargeback, content optimization, and PDT governance"

  tabs:
    - name: executive_overview
      label: "Executive Overview"
    - name: user_chargeback
      label: "User & Department Chargeback"
    - name: content_optimizer
      label: "Content & Dashboard Optimizer"
    - name: pdt_shared_infra
      label: "PDT & Shared Infrastructure"

  filters:
    - name: query_timeframe
      title: "Query Timeframe"
      type: field_filter
      default_value: "30 day"
      allow_multiple_values: true
      required: false
      ui_config:
        type: relative_timeframes
        display: inline
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: bigquery_looker_jobs.query_time_date

    - name: is_looker_query
      title: "Is Looker Query"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: bigquery_looker_jobs.is_looker_query

    - name: project_id
      title: "GCP Project ID"
      type: field_filter
      default_value: "YOUR_PROJECT_ID"
      allow_multiple_values: false
      required: true
      ui_config:
        type: advanced
        display: popover
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: bigquery_looker_jobs.selected_project

    - name: cost_center
      title: "Cost Center"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: checkboxes
        display: popover
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: bigquery_looker_jobs.cost_center

    - name: looker_user
      title: "Looker User"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: bigquery_looker_jobs.looker_user_name

    - name: user_group
      title: "Looker Group"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: looker_users_groups_roles.group_name

    - name: user_role
      title: "Looker Role"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: looker_users_groups_roles.role_name

    - name: cost_per_tb
      title: "Rate ($/TB)"
      type: field_filter
      default_value: "6.25"
      allow_multiple_values: false
      required: false
      ui_config:
        type: advanced
        display: popover
      model: bq_cost_attribution
      explore: looker_cost_analytics
      field: bigquery_looker_jobs.cost_per_tb_rate

  elements:
    # -------------------------------------------------------------
    # TAB 1: EXECUTIVE OVERVIEW
    # -------------------------------------------------------------
    - name: tab1_header_banner
      tab_name: executive_overview
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "## 📈 Executive Spend Overview & Velocity\nMonitor enterprise BigQuery scan volume, gross and net spend, cache efficiency, and high-level cost attribution across business domains, shared infrastructure, and conversational AI."
      row: 0
      col: 0
      width: 24
      height: 2

    - name: kpi_total_gross_cost
      tab_name: executive_overview
      title: "Total Gross Spend"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.total_cost]
      custom_color: "#1A73E8"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 2
      col: 0
      width: 5
      height: 3

    - name: kpi_net_cost_free_tier
      tab_name: executive_overview
      title: "Net Spend (w/ Free Tier Credit)"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.net_cost_with_free_tier]
      custom_color: "#188038"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 2
      col: 5
      width: 5
      height: 3

    - name: kpi_total_tb_billed
      tab_name: executive_overview
      title: "Total Terabytes Billed"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.total_terabytes_billed]
      custom_color: "#F9AB00"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 2
      col: 10
      width: 4
      height: 3

    - name: kpi_cache_hit_rate
      tab_name: executive_overview
      title: "Cache Hit Rate"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.cache_hit_rate]
      custom_color: "#34A853"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 2
      col: 14
      width: 5
      height: 3

    - name: kpi_active_users
      tab_name: executive_overview
      title: "Active Querying Users"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.active_users_count]
      custom_color: "#9334E6"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
      row: 2
      col: 19
      width: 5
      height: 3

    - name: tab1_section1_desc
      tab_name: executive_overview
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### 📊 Spend Velocity & Cost Center Distribution\nAnalyze daily query spend against query volume (dual axes) and view cost allocation across Business Teams, Shared PDTs, Conversational Analytics, and Direct BigQuery."
      row: 5
      col: 0
      width: 24
      height: 2

    - name: daily_spend_trend_chart
      tab_name: executive_overview
      title: "Daily BigQuery Query Spend & Volume Trend"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_line
      fields: [
        bigquery_looker_jobs.query_time_date,
        bigquery_looker_jobs.total_cost,
        bigquery_looker_jobs.query_count
      ]
      sorts: [bigquery_looker_jobs.query_time_date asc]
      limit: 500
      series_types:
        bigquery_looker_jobs.total_cost: column
        bigquery_looker_jobs.query_count: line
      y_axes:
        - orientation: left
          label: "Total Cost ($)"
          showLabels: true
          showValues: true
          unpinAxis: false
          series:
            - id: bigquery_looker_jobs.total_cost
              name: Total Gross Cost ($)
              axisId: bigquery_looker_jobs.total_cost
        - orientation: right
          label: "Query Count"
          showLabels: true
          showValues: true
          unpinAxis: false
          series:
            - id: bigquery_looker_jobs.query_count
              name: Total Queries
              axisId: bigquery_looker_jobs.query_count
      series_colors:
        bigquery_looker_jobs.total_cost: "#4285F4"
        bigquery_looker_jobs.query_count: "#EA4335"
      show_view_names: false
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 7
      col: 0
      width: 14
      height: 8

    - name: cost_center_donut
      tab_name: executive_overview
      title: "Spend by Cost Center"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_pie
      fields: [bigquery_looker_jobs.cost_center, bigquery_looker_jobs.total_cost]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 10
      inner_radius: 50
      series_colors:
        "Business Teams": "#1A73E8"
        "Shared Infrastructure / Looker PDTs": "#34A853"
        "Conversational Analytics": "#9334E6"
        "Shared / Looker System": "#FBBC04"
        "Non-Looker / Direct BigQuery": "#EA4335"
      show_view_names: false
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 7
      col: 14
      width: 10
      height: 8

    - name: tab1_section2_desc
      tab_name: executive_overview
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### 🏆 Top Cost Drivers\nIdentify the highest-spend content assets (dashboards, looks, explores, PDTs) and the top business users driving BigQuery consumption."
      row: 15
      col: 0
      width: 24
      height: 2

    - name: top_expensive_content_table
      tab_name: executive_overview
      title: "Top 5 Most Expensive Dashboards & Content"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.content_name,
        bigquery_looker_jobs.query_source,
        bigquery_looker_jobs.query_count,
        bigquery_looker_jobs.total_terabytes_billed,
        bigquery_looker_jobs.total_cost,
        bigquery_looker_jobs.cache_hit_rate
      ]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 5
      show_view_names: false
      show_row_numbers: true
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 17
      col: 0
      width: 12
      height: 6

    - name: top_expensive_users_table
      tab_name: executive_overview
      title: "Top 5 Most Expensive Users"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.looker_user_name,
        looker_users_groups_roles.group_name,
        bigquery_looker_jobs.query_count,
        bigquery_looker_jobs.total_terabytes_billed,
        bigquery_looker_jobs.total_cost
      ]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 5
      show_view_names: false
      show_row_numbers: true
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 17
      col: 12
      width: 12
      height: 6

    # -------------------------------------------------------------
    # TAB 2: USER & DEPARTMENT CHARGEBACK
    # -------------------------------------------------------------
    - name: tab2_header_banner
      tab_name: user_chargeback
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "## 👥 User & Department Cost Chargeback\nGranular showback and chargeback attribution across Looker User Groups, organizational departments, individual business users, and direct BigQuery accounts."
      row: 0
      col: 0
      width: 24
      height: 2

    - name: tab2_section1_desc
      tab_name: user_chargeback
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### 🏢 Department & Individual User Spend Analysis\nCompare overall team consumption and drill into individual business users, their assigned roles, and average cost per query."
      row: 2
      col: 0
      width: 24
      height: 2

    - name: department_spend_breakdown
      tab_name: user_chargeback
      title: "Spend by Looker User Group / Team"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_column
      fields: [looker_users_groups_roles.group_name, bigquery_looker_jobs.total_cost]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 15
      series_colors:
        bigquery_looker_jobs.total_cost: "#1A73E8"
      show_view_names: false
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 4
      col: 0
      width: 12
      height: 8

    - name: user_spend_breakdown
      tab_name: user_chargeback
      title: "Top Individual Users by Spend"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.looker_user_name,
        bigquery_looker_jobs.looker_user_email,
        looker_users_groups_roles.group_name,
        looker_users_groups_roles.role_name,
        bigquery_looker_jobs.query_count,
        bigquery_looker_jobs.total_terabytes_billed,
        bigquery_looker_jobs.total_cost,
        bigquery_looker_jobs.average_cost_per_query
      ]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 25
      show_view_names: false
      show_row_numbers: true
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 4
      col: 12
      width: 12
      height: 8

    - name: tab2_section2_desc
      tab_name: user_chargeback
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### 🔍 User Query Behavior & Source Distribution\nUnderstand how each user queries BigQuery—whether through dashboards, ad-hoc explores, SQL Runner, conversational AI, or scheduled reports."
      row: 12
      col: 0
      width: 24
      height: 2

    - name: user_query_type_matrix
      tab_name: user_chargeback
      title: "User Query Source Distribution"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_bar
      fields: [
        bigquery_looker_jobs.looker_user_name,
        bigquery_looker_jobs.query_source,
        bigquery_looker_jobs.total_cost
      ]
      pivots: [bigquery_looker_jobs.query_source]
      sorts: [bigquery_looker_jobs.total_cost desc 0]
      limit: 15
      stacking: normal
      show_view_names: false
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 14
      col: 0
      width: 24
      height: 8

    # -------------------------------------------------------------
    # TAB 3: CONTENT & DASHBOARD OPTIMIZER
    # -------------------------------------------------------------
    - name: tab3_header_banner
      tab_name: content_optimizer
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "## ⚡ Content, Explore & Query Optimization\nIdentify optimization opportunities, runaway queries, heavy dashboards with low cache hit rates, and expensive data models."
      row: 0
      col: 0
      width: 24
      height: 2

    - name: tab3_section1_desc
      tab_name: content_optimizer
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### 📊 Dashboard Cost & Inefficiency Ranking\nEvaluate dashboard query costs, cache hit rates, and average cost per query to prioritize datagroup persistence and query optimization."
      row: 2
      col: 0
      width: 24
      height: 2

    - name: dashboard_spend_leaderboard
      tab_name: content_optimizer
      title: "Most Expensive Dashboards"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.dashboard_title,
        bigquery_looker_jobs.query_count,
        bigquery_looker_jobs.cache_hit_rate,
        bigquery_looker_jobs.total_terabytes_billed,
        bigquery_looker_jobs.total_cost,
        bigquery_looker_jobs.average_cost_per_query
      ]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 20
      show_view_names: false
      show_row_numbers: true
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 4
      col: 0
      width: 24
      height: 8

    - name: tab3_section2_desc
      tab_name: content_optimizer
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### 🔬 Explores, Models & Individual Query Deep-Dive\nReview model/explore cost concentrations alongside individual high-cost BigQuery jobs with direct clickable links to the Google Cloud Console."
      row: 12
      col: 0
      width: 24
      height: 2

    - name: expensive_explores_table
      tab_name: content_optimizer
      title: "Most Expensive Explores & Models"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.model_name,
        bigquery_looker_jobs.explore_name,
        bigquery_looker_jobs.query_count,
        bigquery_looker_jobs.total_terabytes_billed,
        bigquery_looker_jobs.total_cost,
        bigquery_looker_jobs.cache_hit_rate
      ]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 20
      show_view_names: false
      show_row_numbers: true
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 14
      col: 0
      width: 12
      height: 8

    - name: runaway_queries_inspector
      tab_name: content_optimizer
      title: "Most Expensive Queries"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.job_id,
        bigquery_looker_jobs.looker_user_name,
        bigquery_looker_jobs.content_name,
        bigquery_looker_jobs.query_time_time,
        bigquery_looker_jobs.runtime_seconds,
        bigquery_looker_jobs.total_gigabytes_billed,
        bigquery_looker_jobs.total_cost
      ]
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 20
      show_view_names: false
      show_row_numbers: true
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        looker_user: bigquery_looker_jobs.looker_user_name
        user_group: looker_users_groups_roles.group_name
        user_role: looker_users_groups_roles.role_name
        cost_center: bigquery_looker_jobs.cost_center
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 14
      col: 12
      width: 12
      height: 8

    # -------------------------------------------------------------
    # TAB 4: PDT & SHARED INFRASTRUCTURE
    # -------------------------------------------------------------
    - name: tab4_header_banner
      tab_name: pdt_shared_infra
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "## 🏗️ Persistent Derived Tables (PDT) & Shared Infrastructure\nMonitor background PDT build costs, regenerator schedules, long-running scratch builds, automated alerts, and scheduled report deliveries."
      row: 0
      col: 0
      width: 24
      height: 2

    - name: kpi_pdt_spend
      tab_name: pdt_shared_infra
      title: "Total Shared PDT Spend"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.total_cost]
      custom_color: "#4285F4"
      filters:
        bigquery_looker_jobs.query_source: "pdt_build"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 2
      col: 0
      width: 8
      height: 3

    - name: kpi_pdt_rebuild_count
      tab_name: pdt_shared_infra
      title: "Total PDT Rebuilds"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.query_count]
      custom_color: "#FBBC04"
      filters:
        bigquery_looker_jobs.query_source: "pdt_build"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
      row: 2
      col: 8
      width: 8
      height: 3

    - name: kpi_pdt_tb_billed
      tab_name: pdt_shared_infra
      title: "PDT Terabytes Billed"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: single_value
      fields: [bigquery_looker_jobs.total_terabytes_billed]
      custom_color: "#34A853"
      filters:
        bigquery_looker_jobs.query_source: "pdt_build"
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 2
      col: 16
      width: 8
      height: 3

    - name: tab4_section1_desc
      tab_name: pdt_shared_infra
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### 🔄 Daily PDT Build Cadence & High-Cost Table Analysis\nTrack daily rebuild spend and identify the most expensive persistent derived tables by gigabytes scanned and execution runtime."
      row: 5
      col: 0
      width: 24
      height: 2

    - name: daily_pdt_spend_trend
      tab_name: pdt_shared_infra
      title: "Daily PDT Rebuild Spend Trend"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_column
      fields: [bigquery_looker_jobs.query_time_date, bigquery_looker_jobs.total_cost]
      filters:
        bigquery_looker_jobs.query_source: "pdt_build"
      sorts: [bigquery_looker_jobs.query_time_date desc]
      limit: 100
      series_colors:
        bigquery_looker_jobs.total_cost: "#4285F4"
      show_view_names: false
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 7
      col: 0
      width: 12
      height: 8

    - name: most_expensive_pdts_table
      tab_name: pdt_shared_infra
      title: "Top Most Expensive & Active PDTs"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.pdt_name,
        bigquery_looker_jobs.query_count,
        bigquery_looker_jobs.total_gigabytes_billed,
        bigquery_looker_jobs.total_cost,
        bigquery_looker_jobs.avg_runtime_seconds
      ]
      filters:
        bigquery_looker_jobs.query_source: "pdt_build"
      sorts: [bigquery_looker_jobs.total_cost desc]
      limit: 25
      show_view_names: false
      show_row_numbers: true
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 7
      col: 12
      width: 12
      height: 8

    - name: tab4_section2_desc
      tab_name: pdt_shared_infra
      type: text
      title_text: ""
      subtitle_text: ""
      body_text: "### ⏰ Automated Background Tasks & Scheduled Deliveries\nAudit spend from scheduled email/webhook deliveries, rendering jobs, and threshold-based alerts running in the background."
      row: 15
      col: 0
      width: 24
      height: 2

    - name: scheduled_and_alert_spend
      tab_name: pdt_shared_infra
      title: "Background Schedules & Alerts Cost"
      model: bq_cost_attribution
      explore: looker_cost_analytics
      type: looker_grid
      fields: [
        bigquery_looker_jobs.query_source,
        bigquery_looker_jobs.looker_user_name,
        bigquery_looker_jobs.query_count,
        bigquery_looker_jobs.total_terabytes_billed,
        bigquery_looker_jobs.total_cost
      ]
      filters:
        bigquery_looker_jobs.query_source: "scheduled_task,alert"
      sorts: [bigquery_looker_jobs.total_cost desc]
      show_view_names: false
      show_row_numbers: true
      limit: 25
      listen:
        query_timeframe: bigquery_looker_jobs.query_time_date
        is_looker_query: bigquery_looker_jobs.is_looker_query
        project_id: bigquery_looker_jobs.selected_project
        cost_per_tb: bigquery_looker_jobs.cost_per_tb_rate
      row: 17
      col: 0
      width: 24
      height: 8
