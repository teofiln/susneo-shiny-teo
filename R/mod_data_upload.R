#' data_upload UI Function
#'
#' @description A file input to upload CSV files.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_upload_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fileInput(
      inputId = ns("file"),
      label = "Upload CSV File",
      accept = c(
        "text/csv",
        "text/comma-separated-values,text/plain",
        ".csv"
      )
    ),
    bslib::card(
      bslib::card_header(
        class = "d-flex justify-content-between align-items-center border-bottom-0", # nolint
        "File Upload Instructions",
        shiny::actionLink(
          ns("hide_help"),
          label = NULL,
          icon = shiny::icon("eye-slash")
        )
      ),
      bslib::card_body(
        class = "text-muted",
        id = ns("help_text"),
        shiny::p(
          "Upload a CSV file containing your dataset. The file should
      include columns 'id', 'site', 'date', 'type', and 'value',
      and 'carbon.emission.in.kgco2e'. If any of these columns
      are missing or incorrectly named, an error will be shown
      after upload."
        ),
        shiny::p(
          "After uploading, the data will be validated automatically.
      If the data is valid, a success message will be shown.
      If there are issues with the data, an error message
      will indicate what needs to be fixed."
        ),
        shiny::p(
          "Once the data is successfully uploaded and validated,
      you can proceed to the next steps in the analysis."
        ),
        shiny::p(
          "To use a demo dataset, toggle the 'Use Demo Data' option
      below."
        )
      )
    ),
    shiny::checkboxInput(
      inputId = ns("use_demo"),
      label = "Use Demo Data",
      value = FALSE
    )
  )
}

#' data_upload Server Functions
#' @description Handles file upload and initializes Data object.
#' Stores two reactive values in session$userData:
#' - data_rct: the uploaded data frame
#' - data_obj_rct: the Data R6 object used for data operations
#' These can be accessed in other modules via
#' session$userData$data_rct() and session$userData$data_obj_rct()
#'
#' Optionally uses demo data from task1::sample_data.
#' @noRd
mod_data_upload_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns # nolint

    # Handle data upload
    session$userData$data_rct <- shiny::reactiveVal(NULL)
    shiny::observeEvent(input$file, {
      shiny::req(input$file)
      tryCatch(
        {
          df <- read.csv(input$file$datapath, stringsAsFactors = FALSE)
          session$userData$data_rct(df)
        },
        error = function(e) {
          shiny::showNotification(
            paste("Error reading file:", e$message),
            type = "error"
          )
        }
      )
    })

    # Initiate Data object when data is uploaded
    session$userData$data_obj_rct <- shiny::reactiveVal(NULL)
    shiny::observeEvent(session$userData$data_rct(), {
      shiny::req(session$userData$data_rct())
      tryCatch(
        {
          data_obj <- Data$new(session$userData$data_rct())
          session$userData$data_obj_rct(data_obj)
          shiny::showNotification(
            "Data validated successfully",
            type = "message"
          )
        },
        error = function(e) {
          shiny::showNotification(
            paste("Data validation error:", e$message),
            type = "error"
          )
        }
      )
    })

    # Use demo data if checkbox is selected
    shiny::observeEvent(input$use_demo, {
      if (isTRUE(input$use_demo)) {
        df <- task1::sample_data
        session$userData$data_rct(df)
        tryCatch(
          {
            data_obj <- Data$new(df)
            session$userData$data_obj_rct(data_obj)
            shiny::showNotification(
              "Demo data loaded and validated successfully",
              type = "message"
            )
          },
          error = function(e) {
            shiny::showNotification(
              paste("Demo data validation error:", e$message),
              type = "error"
            )
          }
        )
      } else {
        session$userData$data_rct(NULL)
        session$userData$data_obj_rct(NULL)
      }
    })

    # handle showing/hiding help text
    shiny::observeEvent(input$hide_help, {
      if (input$hide_help %% 2 == 0) {
        golem::invoke_js("showid", id = ns("help_text"))
        shiny::updateActionLink(
          inputId = "hide_help",
          label = NULL,
          icon = shiny::icon("eye-slash")
        )
        return()
      }

      golem::invoke_js("hideid", id = ns("help_text"))
      shiny::updateActionLink(
        inputId = "hide_help",
        label = NULL,
        icon = shiny::icon("eye")
      )
    })
  })
}
