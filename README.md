
# tarchetypes

[![wip](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![check](https://github.com/wlandau/tarchetypes/workflows/check/badge.svg)](https://github.com/wlandau/tarchetypes/actions?query=workflow%3Acheck)
[![lint](https://github.com/wlandau/tarchetypes/workflows/lint/badge.svg)](https://github.com/wlandau/tarchetypes/actions?query=workflow%3Alint)
[![codecov](https://codecov.io/gh/wlandau/tarchetypes/branch/master/graph/badge.svg?token=3T5DlLwUVl)](https://codecov.io/gh/wlandau/targets)

The `tarchetypes` R package is a collection of target and pipeline
archetypes for the [`targets`](https://github.com/wlandau/targets)
package. These archetypes are shorthand that makes it easier to read and
write pipelines.

## Target archetype example

Consider the following R Markdown report.

    ---
    title: report
    output: html_document
    ---
    
    ```{r}
    library(targets)
    tar_read(dataset)
    ```

We want to define a target to render the report. And because the report
calls `tar_read(dataset)`, this target needs to depend on `dataset`.
Without `tarchetypes`, it is cumbersome to set up the pipeline
correctly.

``` r
# _targets.R
library(targets)
tar_pipeline(
  tar_target(dataset, data.frame(x = letters)),
  tar_target(
    report, {
      # Explicitly mention the symbol `dataset`.
      list(data)
      # Return relative paths to keep the project portable.
      fs::path_rel(
        # Need to return/track all input/output files.
        c( 
          rmarkdown::render(
            input = "report.Rmd",
            # Always run from the project root
            # so the report can find _targets/.
            knit_root_dir = getwd(),
            quiet = TRUE
          ),
          "report.Rmd"
        )
      )
    },
    # Track the input and output files.
    format = "file",
    # Avoid building small reports on HPC.
    deployment = "local"
  )
)
```

With `tarchetypes`, we can simplify the pipeline with the `tar_render()`
archetype.

``` r
# _targets.R
library(targets)
library(tarchetypes)
tar_pipeline(
  tar_target(dataset, data.frame(x = letters)),
  tar_render(report, "report.Rmd")
)
```

Above, `tar_render()` scans code chunks for mentions of targets in
`tar_load()` and `tar_read()`, and it enforces the dependency
relationships it finds. In our case, it reads `report.Rmd` and then
forces `report` to depend on `dataset`. That way, `tar_make()` always
processes `dataset` before `report`, and it automatically reruns
`report.Rmd` whenever `dataset`
changes.

## Pipeline archetype example

[`tar_plan()`](https://wlandau.github.io/tarchetypes/reference/tar_plan.html)
is a version of
[`tar_pipeline()`](https://wlandau.github.io/targets/reference/tar_pipeline.html)
that looks and feels like
[`drake_plan()`](https://docs.ropensci.org/drake/reference/drake_plan.html).
For simple targets with no configuration, you can write `target =
command` instead of `tar_target(target, command)`. Ordinarily, pipelines
in `_targets.R` are written like this:

``` r
tar_pipeline(
  tar_target(
    raw_data_file,
    "data/raw_data.csv",
    format = "file"
  ),
  tar_target(
    raw_data,
    read_csv(raw_data_file, col_types = cols())
  ),
  tar_target(
    data,
    raw_data %>%
      mutate(Ozone = replace_na(Ozone, mean(Ozone, na.rm = TRUE)))
  ),
  tar_target(hist, create_plot(data)),
  tar_target(fit, biglm(Ozone ~ Wind + Temp, data)),
  tar_render(report, "report.Rmd")
)
```

With
[`tar_plan()`](https://wlandau.github.io/tarchetypes/reference/tar_plan.html),
the simplest targets become super easy to write.

``` r
tar_plan(
  # Needs tar_target() because of format = "file":
  tar_target(
    raw_data_file,
    "data/raw_data.csv",
    format = "file"
  ),
  # Simple drake-like syntax:
  raw_data = read_csv(raw_data_file, col_types = cols()),
  data =raw_data %>%
    mutate(Ozone = replace_na(Ozone, mean(Ozone, na.rm = TRUE))),
  hist = create_plot(data),
  fit = biglm(Ozone ~ Wind + Temp, data),
  # Needs tar_render() because it is a target archetype:
  tar_render(report, "report.Rmd")
)
```

## Installation

Install the GitHub development version to access the latest features and
patches.

``` r
library(remotes)
install_github("wlandau/tarchetypes")
```

## Documentation

  - [Reference](https://wlandau.github.io/tarchetypes/): package
    website.
  - [Functions](https://wlandau.github.io/tarchetypes/reference/index.html):
    documentation and examples of all user-side functions.

## Examples

The following examples use the `tar_render()` archetype in pipelines.

  - [Minimal example](https://github.com/wlandau/targets-minimal).
  - [Machine learning with
    Keras](https://github.com/wlandau/targets-keras).
  - [Validating a Stan model](https://github.com/wlandau/targets-stan).

## Participation

Development is a community effort, and we welcome discussion and
contribution. By participating in this project, you agree to abide by
the [code of
conduct](https://github.com/wlandau/tarchetypes/blob/master/CODE_OF_CONDUCT.md)
and the [contributing
guide](https://github.com/wlandau/tarchetypes/blob/master/CONTRIBUTING.md).
