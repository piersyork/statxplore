
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statxplore

<!-- badges: start -->

[![R-CMD-check](https://github.com/piersyork/statxplore/workflows/R-CMD-check/badge.svg)](https://github.com/piersyork/statxplore/actions)
<!-- badges: end -->

The goal of statxplore is to …

## Installation

You can install the development version of statxplore from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("piersyork/statxplore")
```

## Example

This is an example of how to get data on the number of PIP Registrations
per month by age

``` r
library(statxplore)

# API_KEY <- "YOUR_API_KEY"

pip_regs_age <- start_query("Personal Independence Payment", "PIP Registrations", API_KEY) |>
  add_measure("PIP Registrations") |>
  add_fields(c("Month", "Age (bands and single year)")) |>
  fetch()
```

## TO-DO

-   [ ] Add caching of data
-   [ ] Add secure storing of APIKey
-   [ ] Add reading APIKey from file
-   [ ] Change method of renaming column names to named vector
-   [ ] Fix ordering of column names
