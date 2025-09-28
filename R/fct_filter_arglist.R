#' filter_arglist
#'
#' @description Generates a list of filter arguments for data filtering.
#' @param data A data frame containing the dataset.
#' @param input A shiny input object containing user inputs for filtering.
#'
#' @return A list of filter arguments.
#'
#' @noRd
filter_arglist <- function(data, input) {
  list(
    site = list(
      col = "site",
      fun = "in",
      value = input$filter_site
    ),
    date = list(
      col = "date",
      fun = "between",
      min = input$filter_date[1],
      max = input$filter_date[2]
    ),
    type = list(
      col = "type",
      fun = "in",
      value = input$filter_type
    ),
    value = list(
      col = "value",
      fun = "between",
      min = input$filter_value[1],
      max = input$filter_value[2]
    ),
    carbon_emission = list(
      col = "carbon.emission.in.kgco2e",
      fun = "between",
      min = input$filter_carbon_emission[1],
      max = input$filter_carbon_emission[2]
    )
  )
}
