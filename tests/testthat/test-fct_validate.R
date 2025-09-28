test_that("[validate_dataset] Validates the dataset structure", {
  # Create a sample valid dataset
  valid_data <- data.frame(
    id = 1:5,
    site = c("A", "B", "C", "D", "E"),
    date = c(
      "2023-01-01",
      "2023-01-02",
      "2023-01-03",
      "2023-01-04",
      "2023-01-05"
    ),
    type = c("X", "Y", "X", "Y", "X"),
    value = c(10.5, 20.3, 15.2, 25.1, 30.0),
    carbon.emission.in.kgco2e = c(1.5, 2.3, 1.8, 2.5, 3.0)
  )
  expect_true(validate_dataset(valid_data))
})

test_that("[validate_dataset] Catches missing required columns", {
  # Create a dataset missing the 'site' column
  invalid_data <- data.frame(
    id = 1:5,
    date = c(
      "2023-01-01",
      "2023-01-02",
      "2023-01-03",
      "2023-01-04",
      "2023-01-05"
    ),
    type = c("X", "Y", "X", "Y", "X"),
    value = c(10.5, 20.3, 15.2, 25.1, 30.0),
    carbon.emission.in.kgco2e = c(1.5, 2.3, 1.8, 2.5, 3.0)
  )
  expect_error(validate_dataset(invalid_data))
})

test_that("[validate_dataset] Catches incorrect column types", {
  # Create a dataset with incorrect types for
  # 'id', 'value', and 'carbon.emission.in.kgco2e'
  invalid_data <- data.frame(
    id = as.character(1:5), # Should be integerish
    site = c("A", "B", "C", "D", "E"),
    date = c(
      "2023-01-01",
      "2023-01-02",
      "2023-01-03",
      "2023-01-04",
      "2023-01-05"
    ),
    type = c("X", "Y", "X", "Y", "X"),
    # Should be numeric
    value = as.character(c(10.5, 20.3, 15.2, 25.1, 30.0)),
    # Should be numeric
    carbon.emission.in.kgco2e = as.character(c(1.5, 2.3, 1.8, 2.5, 3.0))
  )
  expect_error(validate_dataset(invalid_data))
})

test_that("[validate_dataset] Catches invalid date formats", {
  # Create a dataset with an invalid date format
  invalid_data <- data.frame(
    id = 1:5,
    site = c("A", "B", "C", "D", "E"),
    date = c(
      "2023/01/01", # Invalid format
      "2023-01-02",
      "2023-01-03",
      "2023-01-04",
      "2023-01-05"
    ),
    type = c("X", "Y", "X", "Y", "X"),
    value = c(10.5, 20.3, 15.2, 25.1, 30.0),
    carbon.emission.in.kgco2e = c(1.5, 2.3, 1.8, 2.5, 3.0)
  )
  expect_error(validate_dataset(invalid_data))
})

test_that("[validate_dataset] Catches missing values in date column", {
  # Create a dataset with a missing date
  invalid_data <- data.frame(
    id = 1:5,
    site = c("A", "B", "C", "D", "E"),
    date = c(
      "2023-01-01",
      NA, # Missing date
      "2023-01-03",
      "2023-01-04",
      "2023-01-05"
    ),
    type = c("X", "Y", "X", "Y", "X"),
    value = c(10.5, 20.3, 15.2, 25.1, 30.0),
    carbon.emission.in.kgco2e = c(1.5, 2.3, 1.8, 2.5, 3.0)
  )
  expect_error(validate_dataset(invalid_data))
})
