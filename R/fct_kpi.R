#' kpi_total_consumption
#' Calculate total consumption
#'
#' @param data A data frame containing the necessary columns.
#' @return The total consumption value.
#' @noRd
kpi_total_consumption <- function(data) {
  sum(data$value, na.rm = TRUE)
}

#' kpi_average_consumption
#' Calculate average consumption
#'
#' @param data A data frame containing the necessary columns.
#' @return The average consumption value.
#' @noRd
kpi_average_consumption <- function(data) {
  mean(data$value, na.rm = TRUE)
}

#' kpi_peak_consumption
#' Calculate peak consumption
#' @param data A data frame containing the necessary columns.
#' @return The peak consumption value.
#' @noRd
kpi_peak_consumption <- function(data) {
  max(data$value, na.rm = TRUE)
}


#' kpi_total_emissions
#' Calculate total emissions
#' @param data A data frame containing the necessary columns.
#' @return The total emissions value.
#' @noRd
kpi_total_emissions <- function(data) {
  sum(data$carbon.emission.in.kgco2e, na.rm = TRUE)
}

#' kpi_average_emissions
#' Calculate average emissions
#' @param data A data frame containing the necessary columns.
#' @return The average emissions value.
#' @noRd
kpi_average_emissions <- function(data) {
  mean(data$carbon.emission.in.kgco2e, na.rm = TRUE)
}
#' kpi_peak_emissions
#' Calculate peak emissions
#' @param data A data frame containing the necessary columns.
#' @return The peak emissions value.
#' @noRd
kpi_peak_emissions <- function(data) {
  max(data$carbon.emission.in.kgco2e, na.rm = TRUE)
}

#' kpi_efficiency_ratio
#' Calculate efficiency ratio (consumption to emissions)
#' @param data A data frame containing the necessary columns.
#' @return The efficiency ratio value.
#' @noRd
kpi_efficiency_ratio <- function(data) {
  total_consumption <- kpi_total_consumption(data)
  total_emissions <- kpi_total_emissions(data)
  if (total_emissions == 0) {
    return(NA)
  }
  total_consumption / total_emissions
}

#' kpi_average_efficiency_ratio
#' Calculate average efficiency ratio (consumption to emissions)
#' @param data A data frame containing the necessary columns.
#' @return The average efficiency ratio value.
#' @noRd
kpi_average_efficiency_ratio <- function(data) {
  avg_consumption <- kpi_average_consumption(data)
  avg_emissions <- kpi_average_emissions(data)
  if (avg_emissions == 0) {
    return(NA)
  }
  avg_consumption / avg_emissions
}

#' Compute all KPIs
#' @param data A data frame containing the necessary columns.
#' @return A list of all computed KPIs.
#' @noRd
compute_kpis <- function(data) {
  logger::log_debug("[compute_kpis] Computing KPIs")
  kpis <- list(
    total_consumption = kpi_total_consumption(data),
    average_consumption = kpi_average_consumption(data),
    peak_consumption = kpi_peak_consumption(data),
    total_emissions = kpi_total_emissions(data),
    average_emissions = kpi_average_emissions(data),
    peak_emissions = kpi_peak_emissions(data),
    total_efficiency_ratio = kpi_efficiency_ratio(data),
    average_efficiency_ratio = kpi_average_efficiency_ratio(data)
  )
  logger::log_debug("[compute_kpis] Done!")
  kpis
}
