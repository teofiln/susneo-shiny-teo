# CI / GitHub Actions

This project uses a GitHub Actions workflow `.github/workflows/renv-r-cmd-check.yml` to:

- restore the `renv` environment from `renv.lock`
- run package tests
- build a package tarball and run `R CMD check`

## Running the same steps locally

1. Restore packages from `renv`:

```sh
R -e "install.packages('renv', repos='https://cloud.r-project.org'); renv::restore()"
```

2. Run tests:

```sh
R -e "devtools::test()"
```

3. Build and check:

```sh
R CMD build --no-build-vignettes .
R CMD check --no-manual *.tar.gz
```

## Notes

- The workflow caches the `renv` user cache to speed up repeated runs. If you update `renv.lock`, the cache key changes and a fresh restore happens.
- If you need the workflow to run on macOS or Windows, edit `.github/workflows/renv-r-cmd-check.yml` to include additional `runs-on` OS entries in the matrix.
- For coverage reporting (codecov), add a separate workflow or extend the existing one to run `covr::package_coverage()` and upload the results.
