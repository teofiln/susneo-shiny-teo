#' kpis UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_kpis_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("kpis_ui"))
  )
}

#' kpis Server Functions
#'
#' @noRd
mod_kpis_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint

    kpi_ui_rct <- shiny::reactive({
      shiny::req(session$userData$data_obj_rct())
      kpis <- session$userData$data_obj_rct()$kpis()
      kpi_names <- c(
        "total_consumption",
        "total_emissions",
        "total_efficiency_ratio"
      )
      purrr::map(kpi_names, function(kpi_name) {
        bslib::value_box(
          value = formatC(
            kpis[[kpi_name]],
            format = "f",
            big.mark = ",",
            digits = 0
          ),
          title = janitor::make_clean_names(kpi_name, case = "title"),
          showcase = shiny::icon("dashboard")
        )
      })
    }) |>
      shiny::bindEvent(
        session$userData$filter_trigger()
      )

    output$kpis_ui <- shiny::renderUI({
      bslib::layout_column_wrap(
        width = 1 / 3,
        !!!kpi_ui_rct()
      )
    })
  })
}
