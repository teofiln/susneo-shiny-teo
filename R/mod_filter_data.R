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
    "Stuff",
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
            shiny::showNotification(
              "Data filtered successfully",
              type = "message"
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
  })
}
