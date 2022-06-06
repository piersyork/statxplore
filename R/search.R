
#' View the available databases
#'
#' @param API_KEY Your statXplore account API key
#'
#' @return A dataframe of databases
#' @export
#'
#' @examples
#' \dontrun{
#' available_databases("YOUR_API_KEY")
#' }
#'
available_databases <- function(API_KEY) {
  get_schema("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema", API_KEY)
}

#' Show the available datasets for a given database
#'
#' @param database The name of a database returned by available_databases()
#' @param API_KEY Your statXplore account API key
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
available_datasets <- function(database, API_KEY) {
  available_databases(API_KEY)[name == database, location]|>
    get_schema(API_KEY)
}

#' Show the available fields for a given dataset
#'
#' @param database The name of a database returned by available_databases()
#' @param dataset The name of a dataset returned by available_datasets()
#' @param API_KEY Your statXplore account API key
#'
#' @return A dataframe of fields
#' @export
#'
#' @examples
#' \dontrun{
#' available_fields("Personal Independence Payment", "YOUR_API_KEY")
#' }
#'
available_fields <- function(database, dataset, API_KEY) {
  out <- available_datasets(database, API_KEY)[name == dataset, location] |>
    get_schema(API_KEY)

  out[, .(name, location = gsub("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema/", "", location))]
}
