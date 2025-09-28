test_that("Test kpi_total_consumption function", {
  sample_data <- data.frame(
    id = 1:5,
    value = c(10, 20, NA, 30, 40)
  )

  expected_total <- sum(sample_data$value, na.rm = TRUE)
  result <- kpi_total_consumption(sample_data)
  expect_equal(result, expected_total)
})

test_that("Test kpi_average_consumption function", {
  sample_data <- data.frame(
    id = 1:5,
    value = c(10, 20, NA, 30, 40)
  )

  expected_average <- mean(sample_data$value, na.rm = TRUE)
  result <- kpi_average_consumption(sample_data)
  expect_equal(result, expected_average)
})

test_that("Test kpi_peak_consumption function", {
  sample_data <- data.frame(
    id = 1:5,
    value = c(10, 20, NA, 30, 40)
  )
  expected_peak <- max(sample_data$value, na.rm = TRUE)
  result <- kpi_peak_consumption(sample_data)
  expect_equal(result, expected_peak)
})

test_that("Test kpi_total_emissions function", {
  sample_data <- data.frame(
    id = 1:5,
    carbon.emission.in.kgco2e = c(5, 15, NA, 25, 35)
  )

  expected_total <- sum(sample_data$carbon.emission.in.kgco2e, na.rm = TRUE)
  result <- kpi_total_emissions(sample_data)

  expect_equal(result, expected_total)
})

test_that("Test kpi_average_emissions function", {
  sample_data <- data.frame(
    id = 1:5,
    carbon.emission.in.kgco2e = c(5, 15, NA, 25, 35)
  )

  expected_average <- mean(sample_data$carbon.emission.in.kgco2e, na.rm = TRUE)
  result <- kpi_average_emissions(sample_data)
  expect_equal(result, expected_average)
})

test_that("Test kpi_peak_emissions function", {
  sample_data <- data.frame(
    id = 1:5,
    carbon.emission.in.kgco2e = c(5, 15, NA, 25, 35)
  )

  expected_peak <- max(sample_data$carbon.emission.in.kgco2e, na.rm = TRUE)
  result <- kpi_peak_emissions(sample_data)
  expect_equal(result, expected_peak)
})

test_that("Test kpi_efficiency_ratio function", {
  sample_data <- data.frame(
    id = 1:5,
    value = c(10, 20, NA, 30, 40),
    carbon.emission.in.kgco2e = c(5, 15, NA, 25, 35)
  )

  total_consumption <- sum(sample_data$value, na.rm = TRUE)
  total_emissions <- sum(sample_data$carbon.emission.in.kgco2e, na.rm = TRUE)
  expected_ratio <- if (total_emissions == 0) {
    NA
  } else {
    total_consumption / total_emissions
  }

  result <- kpi_efficiency_ratio(sample_data)

  expect_equal(result, expected_ratio)
})

test_that("compute_kpis returns a named list with correct KPIs", {
  sample_data <- data.frame(
    id = 1:5,
    value = c(10, 20, NA, 30, 40),
    carbon.emission.in.kgco2e = c(5, 15, NA, 25, 35)
  )

  result <- compute_kpis(sample_data)
  expect_true(is.list(result))
  expected_names <- c(
    "total_consumption",
    "average_consumption",
    "peak_consumption",
    "total_emissions",
    "average_emissions",
    "peak_emissions",
    "total_efficiency_ratio",
    "average_efficiency_ratio"
  )
  expect_equal(sort(names(result)), sort(expected_names))
  expect_true(all(sapply(result, is.numeric) | sapply(result, is.na)))
})
