test_that("filtering works", {
  d <- iris
  l <- list(
    list(col = "Sepal.Length", fun = "between", min = 4, max = 5),
    list(col = "Species", fun = "in", val = c("setosa", "versicolor"))
  )
  res <- .filter(d, l)
  expect_true(all(res$Sepal.Length >= 4 & res$Sepal.Length <= 5))
  expect_true(all(res$Species %in% c("setosa", "versicolor")))
})

test_that("filtering with NULL values throws error", {
  d <- iris
  l <- list(
    list(col = "Sepal.Length", fun = "between", min = NULL, max = 5),
    list(col = "Species", fun = "in", val = NULL)
  )
  expect_error(.filter(d, l))
})

test_that("filtering with invalid column names throws error", {
  d <- iris
  l <- list(
    list(col = "InvalidColumn", fun = "between", min = 4, max = 5)
  )
  expect_error(.filter(d, l))
})

test_that("filtering with invalid function names throws error", {
  d <- iris
  l <- list(
    list(col = "Sepal.Length", fun = "invalid_fun", min = 4, max = 5)
  )
  expect_error(.filter(d, l))
})

test_that("filtering with empty arglist returns original data", {
  d <- iris
  l <- list()
  res <- .filter(d, l)
  expect_equal(res, d)
})

test_that("filtering with NULL arglist returns original data", {
  d <- iris
  l <- NULL
  res <- .filter(d, l)
  expect_equal(res, d)
})
