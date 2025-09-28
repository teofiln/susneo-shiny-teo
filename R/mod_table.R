#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_table_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$h3("Uploaded Data Preview"),
    reactable::reactableOutput(ns("table"))
  )
}

#' table Server Functions
#'
#' @noRd
mod_table_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint

    output$table <- reactable::renderReactable({
      shiny::req(session$userData$data_obj_rct())
      df <- session$userData$data_obj_rct()$get() |>
        janitor::clean_names(case = "sentence")

      reactable::reactable(
        df,
        searchable = TRUE,
        filterable = TRUE,
        pagination = TRUE,
        defaultPageSize = 15,
        highlight = TRUE,
        bordered = TRUE,
        striped = TRUE,
        theme = reactable::reactableTheme(
          headerStyle = list(backgroundColor = "#f7f7f8"),
          cellPadding = "8px 12px"
        )
      )
    })
  })
}
