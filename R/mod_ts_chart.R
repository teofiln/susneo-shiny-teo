#' ts_chart UI Function
#'
#' @description Render a time series chart using Plotly.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param title Title of the time series chart.
#' @param y_var Variable for y-axis (default is "value").
#' @param agg_fun Aggregation function for y-axis (default is mean).
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ts_chart_ui <- function(id, title) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(title),
    plotly::plotlyOutput(ns("ts_chart"), height = "300px")
  )
}

#' ts_chart Server Functions
#'
#' @noRd
mod_ts_chart_server <- function(id, y_var = "value", agg_fun = mean) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint

    output$ts_chart <- plotly::renderPlotly({
      session$userData$data_obj_rct()$ts_chart(
        y_var = y_var,
        agg_fun = agg_fun
      )
    }) |>
      shiny::bindEvent(
        session$userData$filter_trigger()
      )
  })
}
