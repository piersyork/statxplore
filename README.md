
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statxplore

<!-- badges: start -->
<!-- badges: end -->

The statxplore r package acts as a wrapper around DWP’s statXplore API
for published statistics on benefits, pensions and other areas.

## Installation

The package is not yet available on CRAN, you can install the
development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("piersyork/statxplore")
```

## Example

To search for available data, you can use `available_databases()` to see
which benefits have data available. `available_datasets()` then provides
a breakdown of available data for the benefit. `available_fields()`
provides the variable names (measure and fields) used to make a query.

``` r
library(statxplore)

set_api_key("your_api_key") # available in your statXplore account settings

available_databases() # return available databases (topic areas) 

available_datasets(database = "Personal Independence Payment") # what datasets are available for the database

available_fields(database = "Personal Independence Payment", dataset = "PIP Registrations") # what are the avilable measure and fileds
```

Using results from the search, here is an example of how to get data on
the number of PIP Registrations per month by age

``` r

pip_regs_age <- start_query(database = "Personal Independence Payment", dataset = "PIP Registrations") |>
  add_measure("PIP Registrations") |>
  add_fields(c("Month", "Age (bands and single year)")) |>
  fetch()
```

## TO-DO

-   [x] Add secure storing of APIKey
-   [ ] Add ability to fetch data by geography
-   [ ] Add reading APIKey from file
-   [ ] Change method of renaming column names to named vector
-   [ ] Fix ordering of column names
-   [ ] Add caching of data
