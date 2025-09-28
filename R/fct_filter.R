#' Filter a dataset
#' @description A function to filter a data frame based on specified list.
#' The list should contain elements with the following structure:
#' - col: the name of the column to filter on
#' - fun: the filtering function to use ("between" or "in")
#' - min, max: the range for "between" filters
#' - val: the values for "in" filters
#'
#' Modified from Teofil Nakov's blog:
#' https://discindo.org/posts/2025-01-31-filter-snippet/
#'
#' @param data the data frame
#' @param arglist a list of filter specifications
#' @examples
#' d <- iris
#' l <- list(
#'   list(col = "Sepal.Length", fun = "between", min = 4, max = 5),
#'   list(col = "Species", fun = "in", val = c("setosa", "versicolor"))
#' )
#' .filter(d, l)
#' @importFrom checkmate assert_data_frame assert_list assert_subset
#' @importFrom purrr pluck map reduce map_chr
#' @importFrom dplyr filter between intersect
#' @importFrom rlang sym
#' @export
.filter <- function(data, arglist) {
  checkmate::assert_list(arglist, types = "list", null.ok = TRUE)

  if (is.null(arglist) || length(arglist) == 0) {
    return(data)
  }

  checkmate::assert_data_frame(data)
  checkmate::assert_subset(
    purrr::map_chr(arglist, purrr::pluck, "col"),
    choices = names(data)
  )
  checkmate::assert_subset(
    purrr::map_chr(arglist, purrr::pluck, "fun"),
    choices = c("in", "between")
  )

  # ensure that for "in" filters the `val` field is has no missing values
  in_filters <- purrr::keep(arglist, ~ purrr::pluck(., "fun") == "in")
  if (length(in_filters) > 0) {
    purrr::walk(in_filters, function(f) {
      # disallow NULL and missing (NA) entries
      checkmate::assert_vector(f$val, any.missing = FALSE, null.ok = FALSE)
    })
  }

  bw_filters <- purrr::keep(arglist, ~ purrr::pluck(., "fun") == "between")
  if (length(bw_filters) > 0) {
    purrr::walk(bw_filters, function(f) {
      # disallow NULL and missing (NA) entries
      checkmate::assert_number(f$min, null.ok = FALSE)
      checkmate::assert_number(f$max, null.ok = FALSE)
    })
  }

  purrr::map(arglist, function(x) {
    col <- x$col
    fun <- x$fun
    if (fun == "between") {
      min <- x$min
      max <- x$max
      if (is.null(min) || is.null(max)) {
        return(data)
      }
      return(
        dplyr::filter(
          data,
          dplyr::between(
            !!rlang::sym(col),
            min,
            max
          )
        )
      )
    }
    if (fun == "in") {
      val <- x$val
      if (is.null(val)) {
        return(data)
      }
      return(dplyr::filter(
        data,
        `%in%`(
          as.character(!!rlang::sym(col)),
          val
        )
      ))
    }
  }) |>
    purrr::reduce(dplyr::intersect)
}
