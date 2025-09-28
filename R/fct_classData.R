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
#' data_obj$validate()
#' kpis <- data_obj$kpis()
#' filters <- list(
#'   list(col = "value", fun = "between", min = 10, max = 50)
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
      self$filtered_data <- .filter(self$data, arglist)
      self$filtered <- TRUE
      invisible(self$filtered_data)
    }
  ),
  private = list(
    coerce_date_cols = function() {
      logger::log_debug("[Data:coerce_date_cols] Coercing date columns")
      self$data$date <- as.Date(self$data$date, format = "%Y-%m-%d")
    }
  )
)
