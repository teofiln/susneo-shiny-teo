#' summary_table UI Function
#'
#' @description Render a summary table of key metrics.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_summary_table_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    reactable::reactableOutput(ns("summary_table"))
  )
}

#' summary_table Server Functions
#'
#' @noRd
mod_summary_table_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint
    output$summary_table <- reactable::renderReactable({
      reactable::reactable(
        session$userData$data_obj_rct()$summary_table(),
        bordered = TRUE,
        highlight = TRUE,
        striped = TRUE,
        compact = TRUE,
        defaultPageSize = 15,
        showPageSizeOptions = FALSE,
        columns = list(
          Metric = reactable::colDef(name = "Metric", align = "left"),
          Value = reactable::colDef(name = "Value", align = "right")
        )
      )
    }) |>
      shiny::bindEvent(
        session$userData$filter_trigger()
      )
  })
}
