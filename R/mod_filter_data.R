#' filter_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filter_data_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::layout_sidebar(
    mod_kpis_ui(ns("kpis")),
    bslib::layout_column_wrap(
      widths = 1 / 3,
      mod_ts_chart_ui(
        ns("ts_value"),
        title = "Time Series of Consumption (Daily average)"
      ),
      mod_ts_chart_ui(
        ns("ts_emission"),
        title = "Time Series of Carbon Emissions (kgCO2e, Daily average)"
      ),
      mod_summary_table_ui(ns("summary_table"))
    ),
    bslib::layout_column_wrap(
      widths = 1 / 4,
      mod_bar_chart_ui(
        ns("bar_chart1"),
        title = "Average Consumption by Site"
      ),
      mod_bar_chart_ui(
        ns("bar_chart2"),
        title = "Average Carbon Emission by Site"
      ),
      mod_bar_chart_ui(
        ns("bar_chart3"),
        title = "Average Consumption by Type"
      ),
      mod_bar_chart_ui(
        ns("bar_chart4"),
        title = "Average Carbon Emission by Type"
      )
    ),
    sidebar = bslib::sidebar(
      width = 300,
      shiny::tagList(
        shiny::tags$h3("Filter"),
        shiny::selectInput(
          inputId = ns("filter_site"),
          label = "Select Site(s)",
          choices = NULL,
          selected = NULL,
          multiple = TRUE
        ),
        shiny::dateRangeInput(
          inputId = ns("filter_date"),
          label = "Select Date Range",
          start = NULL,
          end = NULL,
          min = NULL,
          max = NULL
        ),
        shiny::selectInput(
          inputId = ns("filter_type"),
          label = "Select Type(s)",
          choices = NULL,
          selected = NULL,
          multiple = TRUE
        ),
        shiny::sliderInput(
          inputId = ns("filter_value"),
          label = "Select Value Range",
          min = 0,
          max = 100,
          value = c(0, 100)
        ),
        shiny::sliderInput(
          inputId = ns("filter_carbon_emission"),
          label = "Select Carbon Emission Range (kgCO2e)",
          min = 0,
          max = 100,
          value = c(0, 100)
        ),
        shiny::tags$hr(),
        shiny::actionButton(
          inputId = ns("apply_filters"),
          label = "Apply Filters"
        )
      )
    )
  )
}

#' filter_data Server Functions
#'
#' @noRd
mod_filter_data_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint

    # Update filter inputs based on data
    shiny::observe({
      shiny::req(session$userData$data_obj_rct()$validated)
      data <- session$userData$data_obj_rct()$get()

      shiny::updateSelectInput(
        session,
        "filter_site",
        choices = sort(unique(data$site)),
        selected = unique(data$site)
      )
      shiny::updateDateRangeInput(
        session,
        "filter_date",
        start = min(data$date),
        end = max(data$date),
        min = min(data$date),
        max = max(data$date)
      )
      shiny::updateSelectInput(
        session,
        "filter_type",
        choices = sort(unique(data$type)),
        selected = unique(data$type)
      )
      shiny::updateSliderInput(
        session,
        "filter_value",
        min = floor(min(data$value, na.rm = TRUE)),
        max = ceiling(max(data$value, na.rm = TRUE)),
        value = c(
          floor(min(data$value, na.rm = TRUE)),
          ceiling(max(data$value, na.rm = TRUE))
        )
      )
      shiny::updateSliderInput(
        session,
        "filter_carbon_emission",
        min = floor(min(data$carbon.emission.in.kgco2e, na.rm = TRUE)),
        max = ceiling(max(data$carbon.emission.in.kgco2e, na.rm = TRUE)),
        value = c(
          floor(min(data$carbon.emission.in.kgco2e, na.rm = TRUE)),
          ceiling(max(data$carbon.emission.in.kgco2e, na.rm = TRUE))
        )
      )
    })

    # Apply filters to data
    session$userData$filter_trigger <- shiny::reactiveVal(runif(1))
    shiny::observeEvent(
      input$apply_filters,
      {
        shiny::req(session$userData$data_obj_rct()$validated)
        filter_list <- filter_arglist(
          session$userData$data_obj_rct()$get(),
          input
        )
        tryCatch(
          {
            session$userData$data_obj_rct()$filter(filter_list)
            session$userData$data_obj_rct()$get()
            shiny::showNotification(
              "Data filtered successfully",
              type = "message"
            )
            session$userData$filter_trigger(
              runif(1)
            )
          },
          error = function(e) {
            shiny::showNotification(
              paste("Data filtering error:", e$message),
              type = "error"
            )
          }
        )
      },
      ignoreNULL = FALSE
    )

    # Render KPIs
    mod_kpis_server("kpis")

    # Render Time Series Charts
    mod_ts_chart_server("ts_value", y_var = "value")
    mod_ts_chart_server("ts_emission", y_var = "carbon.emission.in.kgco2e")

    # Render Summary Table
    mod_summary_table_server("summary_table")

    # Render Bar Charts
    mod_bar_chart_server(
      "bar_chart1",
      x_var = "site",
      y_var = "value"
    )
    mod_bar_chart_server(
      "bar_chart2",
      x_var = "site",
      y_var = "carbon.emission.in.kgco2e"
    )
    mod_bar_chart_server(
      "bar_chart3",
      x_var = "type",
      y_var = "value"
    )
    mod_bar_chart_server(
      "bar_chart4",
      x_var = "type",
      y_var = "carbon.emission.in.kgco2e"
    )
  })
}
