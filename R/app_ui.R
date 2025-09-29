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
    bslib::page_navbar(
      title = shiny::tags$img(
        class = "me-5",
        src = "www/logo.png",
        height = "25px"
      ),
      theme = bslib::bs_theme(
        version = 5,
        primary = "#4eb5ab",
        font_scale = 0.8,
        base_font = bslib::font_google("Lato"),
      ),
      fluid = TRUE,
      bslib::nav_spacer(),
      bslib::nav_item(shiny::tags$strong(
        class = "fs-4",
        "Consumption & Emissions Analysis"
      )),
      bslib::nav_spacer(),
      bslib::nav_panel("Data", mod_data_upload_ui("data_upload")),
      bslib::nav_panel("Dashboard", mod_dashboard_ui("filter_data"))
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
    golem::favicon(ext = "png"),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "Susneo Consumption & Emissions Analysis"
    ),
    golem::activate_js()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
