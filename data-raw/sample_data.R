# Prepare sample dataset as internal data of the package
# Stores the dataset in data/sample_data.rda
# and documents it in R/sample_data.R
sample_data <- read.csv("inst/extdata/SAMPLE ASSIGNMENT DATA.csv")
usethis::use_data(sample_data, overwrite = TRUE)
