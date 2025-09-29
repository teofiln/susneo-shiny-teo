#' bar_chart
#'
#' @description A function to create a bar chart using plotly.
#' It aggregates the y_var by averaging over the x_var.
#' The bars are colored using a gradient palette.
#' @param data A data frame containing the data to plot.
#' @param x_var The name of the column to use for the x-axis (categorical).
#' @param y_var The name of the column to use for the y-axis (numeric).
#' @importFrom checkmate assert_data_frame assert_string assert_subset
#' @importFrom dplyr group_by summarise mutate
#' @importFrom plotly plot_ly layout
#'
#' @return A plotly object representing the bar chart.
#'
#' @noRd
bar_chart <- function(data, x_var, y_var) {
  checkmate::assert_data_frame(data)
  checkmate::assert_string(x_var)
  checkmate::assert_string(y_var)
  checkmate::assert_subset(c(x_var, y_var), choices = names(data))

  if (!is.numeric(data[[y_var]])) {
    stop(sprintf("`%s` must be numeric", y_var))
  }

  agg <- data |>
    dplyr::group_by(.data[[x_var]]) |>
    dplyr::summarise(
      !!rlang::sym(y_var) := mean(.data[[y_var]], na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(!!rlang::sym(x_var) := as.character(.data[[x_var]]))

  # create a palette around the primary color (#4eb5ab)
  n_bars <- nrow(agg)
  # light; base; dark
  base_shades <- c("#dff6f3", "#4eb5ab", "#0f6b63")
  palette <- grDevices::colorRampPalette(base_shades)(max(1, n_bars))

  p <- plotly::plot_ly(
    x = agg[[x_var]],
    y = agg[[y_var]],
    type = "bar",
    marker = list(color = palette),
    hoverinfo = "x+y"
  )

  p <- plotly::layout(
    p,
    xaxis = list(title = x_var),
    yaxis = list(title = y_var)
  )

  p
}
