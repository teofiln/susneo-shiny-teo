#' ts_chart
#'
#' @description Plot a time series chart.
#' A step chart is used to clearly indicate changes at specific points in time.
#' The x-axis represents dates, while the y-axis represents
#' the specified variable.
#' @param data a data frame containing at least 'date' and
#' the specified y_var columns
#' @param y_var the name of the variable to plot on the
#' y-axis (default is "value")
#' @param agg_fun the aggregation function to use if there
#' are multiple observations per date (default is mean)
#'
#' @return a plotly object
#'
#' @noRd
ts_chart <- function(data, y_var = "value", agg_fun = mean) {
  checkmate::assert_data_frame(data)
  checkmate::assert_string(y_var)
  checkmate::assert_subset(y_var, choices = names(data))
  if (!"date" %in% names(data)) {
    stop("`data` must contain a `date` column")
  }
  if (!inherits(data$date, "Date")) {
    stop("`date` column must be of class Date")
  }

  # if there are multiple observations per date, collapse them first (dplyr)
  if (any(duplicated(data$date))) {
    agg_fun <- match.fun(agg_fun)
    data <- data |>
      dplyr::group_by(date) |>
      dplyr::summarise(
        !!rlang::sym(y_var) := agg_fun(.data[[y_var]], na.rm = TRUE),
        .groups = "drop"
      )
  }

  # ensure ordering by date
  data <- dplyr::arrange(data, date)

  # single-trace step chart with specified colour and translucent area
  p <- plotly::plot_ly(
    x = data$date,
    y = data[[y_var]],
    type = "scatter",
    mode = "lines",
    line = list(shape = "hv", color = "#4eb5ab"),
    fill = "tozeroy",
    fillcolor = "rgba(78,181,171,0.15)",
    name = y_var,
    hoverinfo = "x+y"
  )

  p <- plotly::layout(
    p,
    xaxis = list(title = "Date"),
    yaxis = list(title = y_var)
  )

  p
}
