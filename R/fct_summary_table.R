#' summary_table
#'
#' @description A function to generate a summary table of key statistics
#'
#' @return a data frame with summary statistics
#'
#' @noRd
summary_table <- function(data) {
  if (nrow(data) == 0) {
    return(data.frame())
  }

  summary_df <- data.frame(
    Metric = c(
      "Total Records",
      "Sites",
      "Types",
      "Date Range",
      "Average Consumption Value",
      "Total Consumption Value",
      "Peak Consumption Value",
      "Peak Consumption Date",
      "Average Carbon Emission (kgCO2e)",
      "Total Carbon Emission (kgCO2e)",
      "Peak Carbon Emission (kgCO2e)",
      "Peak Carbon Emission Date",
      "Average Efficiency (Value/Carbon Emission)",
      "Total Efficiency (Value/Carbon Emission)"
    ),
    Value = c(
      nrow(data),
      paste0(unique(data$site), collapse = ", "),
      paste0(unique(data$type), collapse = ", "),
      paste0(min(data$date), " to ", max(data$date)),
      round(mean(data$value, na.rm = TRUE), 2),
      round(sum(data$value, na.rm = TRUE), 2),
      round(max(data$value, na.rm = TRUE), 2),
      format(data$date[which.max(data$value)], "%d-%m-%Y"),
      round(mean(data$carbon.emission.in.kgco2e, na.rm = TRUE), 2),
      round(sum(data$carbon.emission.in.kgco2e, na.rm = TRUE), 2),
      round(max(data$carbon.emission.in.kgco2e, na.rm = TRUE), 2),
      format(data$date[which.max(data$carbon.emission.in.kgco2e)], "%d-%m-%Y"),
      round(mean(data$value / data$carbon.emission.in.kgco2e, na.rm = TRUE), 2),
      round(sum(data$value / data$carbon.emission.in.kgco2e, na.rm = TRUE), 2)
    )
  )

  return(summary_df)
}
