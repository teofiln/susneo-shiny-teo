#' validate_dataset
#'
#' @description A function to validate the dataset.
#' @param input_data A data.frame to validate.
#'
#' @return Either TRUE or an error message.
#'
#' @export
#' @examples
#' validate_dataset(sample_data)
validate_dataset <- function(input_data = NULL) {
  logger::log_debug("[validate_dataset] Validating dataset.")

  # Ensure input is a data.frame
  checkmate::assert_data_frame(input_data)

  # Ensure it has the required columns
  checkmate::assert_names(
    x = names(input_data),
    must.include = c(
      "id",
      "site",
      "date",
      "type",
      "value",
      "carbon.emission.in.kgco2e"
    )
  )

  # Validate column types
  checkmate::assert_integerish(input_data$id)
  checkmate::assert_character(input_data$site)
  checkmate::assert_character(input_data$type)
  checkmate::assert_character(input_data$date)
  checkmate::assert_numeric(input_data$value)
  checkmate::assert_numeric(input_data$carbon.emission.in.kgco2e)

  # Validate dates are safely convertible to date class
  date_parsed <- as.Date(input_data$date, format = "%d-%m-%Y")
  checkmate::assert_date(date_parsed, any.missing = FALSE)

  logger::log_debug("[validate_dataset] Done!")
  return(TRUE)
}
