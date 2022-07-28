
#' View the available databases
#'
#'
#' @return A dataframe of databases
#' @export
#'
#' @examples
#' \dontrun{
#' available_databases("YOUR_API_KEY")
#' }
#'
available_databases <- function() {
  get_schema("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema")
}

#' Show the available datasets for a given database
#'
#' @param database The name of a database returned by available_databases()
#'
#' @return A dataframe of datasets
#' @export
#'
#' @import data.table
#'
#' @examples
#'
#' \dontrun{
#' available_datasets("Personal Independence Payment", "YOUR_API_KEY")
#' }
#'
available_datasets <- function(database) {
  available_databases()[name == database, location]|>
    get_schema()
}

#' Show the available fields for a given dataset
#'
#' @param database The name of a database returned by available_databases()
#' @param dataset The name of a dataset returned by available_datasets()
#'
#' @return A dataframe of fields
#' @export
#'
#' @examples
#' \dontrun{
#' available_fields("Personal Independence Payment", "YOUR_API_KEY")
#' }
#'
available_fields <- function(database, dataset) {
  out <- available_datasets(database)[name == dataset, location] |>
    get_schema()

  out[, .(name, location = gsub("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema/", "", location))]
}
