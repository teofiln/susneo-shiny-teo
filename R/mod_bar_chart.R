#' bar_chart UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
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
