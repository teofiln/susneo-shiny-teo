#' classData
#'
#' @description A R6 class to encapsulate dataset operations
#' including filtering, validation, and KPI calculation.
#'
#' @return An R6 class object with methods to manage and analyze the dataset.
#'
#' @importFrom R6 R6Class
#' @importFrom logger log_debug
#'
#' @examples
#' \dontrun{
#' d <- task1::sample_data
#' data_obj <- Data$new(d)
#' kpis <- data_obj$kpis()
#' filters <- list(
#'   list(col = "value", fun = "between", min = 100, max = 200)
#' )
#' data_obj$filter(filters)
#' filtered_data <- data_obj$get()
#' data_obj$filtered  # TRUE
#' data_obj$validated # TRUE
#' data_obj$filter(list()) # no filtering, returns original data
#' data_obj$get() # returns original data
#' }
#'
#' @export
# nolint start
Data <- R6::R6Class(
  # nolint end
  "Data",
  public = list(
    #' @field data The original dataset.
    data = NULL,
    #' @field filtered_data The filtered dataset.
    filtered_data = NULL,
    #' @field validated Logical, whether the dataset has been validated.
    validated = FALSE,
    #' @field filtered Logical, whether the dataset has been filtered.
    filtered = FALSE,
    #' @param data A data frame containing the dataset.
    #' @param validate Logical, whether to validate the dataset
    #' upon initialization.
    initialize = function(data, validate = TRUE) {
      logger::log_debug("[Data:initialize] Initializing Data object")
      self$data <- data
      if (isTRUE(validate)) {
        logger::log_debug("[Data:initialize] Running validation on initialize")
        # let validate() set self$validated (and throw error if invalid)
        self$validate()
      }
      private$coerce_date_cols()
    },
    #' @description Get the current dataset.
    #' If filtered, returns the filtered dataset.
    #' @return The current dataset (filtered or original).
    get = function() {
      logger::log_debug("[Data:get] Retrieving data")
      if (isTRUE(self$filtered)) {
        logger::log_debug("[Data:get] Returning filtered data")
        return(self$filtered_data)
      }
      return(self$data)
    },
    #' @description Validate the dataset against required structure and types.
    #' Sets the `validated` flag to TRUE if successful.
    #' @return TRUE if validation is successful, otherwise throws an error.
    validate = function() {
      logger::log_debug("[Data:validate] Validating data")
      validate_dataset(self$data)
      self$validated <- TRUE
      invisible(TRUE)
    },
    #' @description Calculate and return key performance indicators (KPIs).
    #' See `?task1::compute_kpis` for details.
    #' @return A list of computed KPIs.
    kpis = function() {
      logger::log_debug("[Data:kpis] Calculating KPIs")
      if (isTRUE(self$filtered)) {
        logger::log_debug("[Data:kpis] Using filtered data for KPIs")
        return(compute_kpis(self$filtered_data))
      }
      return(compute_kpis(self$data))
    },
    #' @description Filter the dataset based on specified criteria.
    #' Uses the `.filter` function to apply the filters.
    #' Sets the `filtered` flag to TRUE and stores the filtered dataset.
    #' @param arglist A list of filter specifications.
    #' See `?task1::.filter` for details.
    #' @return The filtered dataset.
    filter = function(arglist) {
      logger::log_debug("[Data:filter] Filtering data")
      res <- .filter(self$data, arglist)
      if (!is.data.frame(res)) {
        logger::log_debug(
          "[Data:filter] Filter did not return a data.frame; no update performed" # nolint
        )
        self$filtered <- FALSE
        self$filtered_data <- NULL
        return(invisible(NULL))
      }
      self$filtered_data <- res
      self$filtered <- TRUE
      invisible(self$filtered_data)
    },
    #' @description Get a time series chart of the specified variable.
    #' Uses the `ts_chart` function to create the chart.
    #' @param y_var The name of the variable to plot on the y-axis.
    #' Default is "value".
    #' @param agg_fun The aggregation function to use if there are
    #' multiple observations per date (default is mean).
    #' @return A plotly object representing the time series chart.
    ts_chart = function(y_var = "value", agg_fun = mean) {
      logger::log_debug("[Data:ts_chart] Generating time series chart")
      ts_chart(self$get(), y_var, agg_fun)
    },
    #' @description Get a summary table of key statistics.
    #' Uses the `summary_table` function to create the table.
    #' @return A data frame with summary statistics.
    summary_table = function() {
      logger::log_debug("[Data:summary_table] Generating summary table")
      summary_table(self$get())
    },
    #' @description Get a bar chart of the specified variables.
    #' Uses the `bar_chart` function to create the chart.
    #' @param x_var The name of the variable to plot on the x-axis.
    #' @param y_var The name of the variable to plot on the y-axis.
    #' @return A plotly object representing the bar chart.
    bar_chart = function(x_var, y_var) {
      logger::log_debug("[Data:bar_chart] Generating bar chart")
      bar_chart(self$get(), x_var, y_var)
    }
  ),
  private = list(
    coerce_date_cols = function() {
      logger::log_debug("[Data:coerce_date_cols] Coercing date columns")
      self$data$date <- as.Date(self$data$date, format = "%d-%m-%Y")
    }
  )
)
