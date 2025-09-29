# task1 — Susneo Consumption & Emissions Analysis

An R package containing a small Shiny dashboard for exploring consumption and carbon emissions data. The package bundles helper functions, modules, and an R6 `Data` class to encapsulate dataset operations.

## 1. Setup Instructions

Prerequisites:

- R (>= 4.1 recommended)
- Git

Install and restore project dependencies (uses `renv`):

```sh
R -e "install.packages('renv', repos='https://cloud.r-project.org'); renv::restore()"
```

Run the app locally during development:

```r
# from the package root
source("dev/run_dev.R")
```

Alternatively, use `R CMD build` and `R CMD check` as described in the Testing section.

## 2. App Overview

The dashboard provides:

- KPI summary boxes (total consumption, total emissions, efficiency)
- Time series step charts for consumption and emissions
- Bar charts summarising consumption and emissions by site/type
- A summary table with date range and peak days
- Filter controls to restrict the dataset by site, date range, type, value and carbon emission

## 3. Architecture

High-level structure:

- R/: package R code. Key components:

  - `mod_*` files: Shiny modules (UI + server) for different app parts (KPIs, charts, bar charts, tables, upload, dashboard).

  - `fct_*` files: pure functions used by modules (chart builders, KPI calculators, filter helpers, validation functions).

  - `fct_classData.R`: Contains the `Data` R6 class which encapsulates the dataset and exposes methods:

    - `initialize(data, validate = TRUE)`: validates and normalises data on creation

    - `get()`: returns the active dataset (filtered if filters applied)

    - `filter(arglist)`: applies filters and stores the filtered dataset

    - `kpis()`, `bar_chart()`, `ts_chart()`, `summary_table()`: convenience methods delegating to package helper functions

Design notes:

- Modules are isolated and receive their UI namespace. They read the shared `Data` object from `session$userData$data_obj_rct()` so all modules show a consistent view.

- Filtering sets a `session$userData$filter_trigger` reactive to signal UI modules to re-render when filters change.

- The `Data` R6 object centralises validation, coercion (dates), and storage of the filtered dataset. This keeps modules lightweight and focused on presentation.

## 4. Data

Bundled sample data:

- `inst/extdata/sample_data.csv` — a CSV sample dataset used to build `data/sample_data.rda` which is documented as `sample_data`.

Schema (columns expected):

- `id`: unique identifier (integer-ish)

- `site`: categorical site code

- `date`: date string in `dd-mm-yyyy` format (the code validates and coerces this to `Date`)

- `type`: categorical type (e.g., Electricity, Water, Gas)

- `value`: numeric consumption value

- `carbon.emission.in.kgco2e`: numeric carbon emissions in kg CO2e

If you upload a CSV via the app, it must include these columns; the validator will run and reject malformed datasets.

## 5. Testing

Run tests locally:

```r
devtools::test()
```

Build and run R CMD check locally:

```sh
R CMD build --no-build-vignettes .
R CMD check --no-manual *.tar.gz
```

Continuous Integration:

This repository includes a GitHub Actions workflow (`.github/workflows/renv-r-cmd-check.yml`) that:

- Restores `renv` from `renv.lock`
- Runs tests
- Builds and runs `R CMD check`

---
