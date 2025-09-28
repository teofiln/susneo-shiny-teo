#' classData
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
Data <- R6::R6Class(
  "Data",
  public = list(
    data = NULL,
    filtered_data = NULL,
    validated = FALSE,
    filtered = FALSE,
    initialize = function(data, validate = TRUE) {
      logger::log_debug("[Data:initialize] Initializing Data object")
      self$data <- data
      if (isTRUE(validate)) {
        logger::log_debug("[Data:initialize] Running validation on initialize")
        # let validate() set self$validated (and throw error if invalid)
        self$validate()
      }
    },
    get = function() {
      logger::log_debug("[Data:get] Retrieving data")
      if (isTRUE(self$filtered)) {
        logger::log_debug("[Data:get] Returning filtered data")
        return(self$filtered_data)
      }
      return(self$data)
    },
    validate = function() {
      logger::log_debug("[Data:validate] Validating data")
      validate_dataset(self$data)
      self$validated <- TRUE
      invisible(TRUE)
    },
    kpis = function() {
      logger::log_debug("[Data:kpis] Calculating KPIs")
      return(compute_kpis(self$data))
    },
    filter = function(arglist) {
      logger::log_debug("[Data:filter] Filtering data")
      self$filtered_data <- .filter(self$data, arglist)
      self$filtered <- TRUE
      invisible(self$filtered_data)
    }
  )
)
