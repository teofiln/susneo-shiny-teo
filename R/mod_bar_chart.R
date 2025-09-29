#' bar_chart UI Function
#'
#' @description Render a bar chart using Plotly.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param title Title of the bar chart.
#' @param x_var Variable for x-axis (default is "site").
#' @param y_var Variable for y-axis (default is "value").
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_bar_chart_ui <- function(id, title = "Bar Chart") {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(title),
    plotly::plotlyOutput(ns("bar_chart"))
  )
}

#' bar_chart Server Functions
#'
#' @noRd
mod_bar_chart_server <- function(id, x_var = "site", y_var = "value") {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint
    output$bar_chart <- plotly::renderPlotly({
      session$userData$data_obj_rct()$bar_chart(x_var, y_var)
    }) |>
      shiny::bindEvent(
        session$userData$filter_trigger()
      )
  })
}
