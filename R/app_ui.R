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
      title = shiny::tags$span(
        class = "d-flex align-items-center",
        shiny::tags$img(class = "me-5", src = "www/logo.png", height = "25px"),
        shiny::tags$strong(class = "fs-4", "Consumption & Emissions Analysis")
      ),
      theme = bslib::bs_theme(
        version = 5,
        primary = "#4eb5ab",
        base_font = bslib::font_google("Nunito"),
      ),
      fluid = TRUE,
      sidebar = bslib::sidebar(
        width = 350,
        mod_data_upload_ui("data_upload"),
        shiny::hr(),
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
    ),
    golem::activate_js()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
