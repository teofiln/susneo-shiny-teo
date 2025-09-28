#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @importFrom shiny tagList
#' @importFrom bslib page_sidebar sidebar bs_theme
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bslib::page_sidebar(
      title = "task1",
      theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),
      fluid = TRUE,
      sidebar = bslib::sidebar(
        "Content"
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )

  shiny::tags$head(
    golem::favicon(),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "task1"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
