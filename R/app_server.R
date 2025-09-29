#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom stats runif
#' @importFrom utils read.csv
#' @noRd
app_server <- function(input, output, session) {
  mod_data_upload_server("data_upload")
  mod_dashboard_server("dashboard")
}
