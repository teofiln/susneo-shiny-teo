# task1

Susneo Consumption & Emissions Analysis (R package + Shiny app)

## Quick dev commands

- Install dependencies from `renv.lock`:

```sh
R -e "install.packages('renv', repos='https://cloud.r-project.org'); renv::restore()"
```

- Run tests:

```sh
R -e "devtools::test()"
```

- Run R CMD check:

```sh
R CMD build --no-build-vignettes .
R CMD check --no-manual *.tar.gz
```

## Continuous integration

This repository includes a GitHub Actions workflow that restores the `renv` environment and runs tests and `R CMD check` on pushes and pull requests. See `.github/workflows/renv-r-cmd-check.yml` for details.
