#' Title
#'
#' @param API_KEY
#'
#' @return
#' @export
#'
#' @examples
available_databases <- function(API_KEY) {
  get_schema("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema", API_KEY)
}

#' Title
#'
#' @param database
#' @param API_KEY
#'
#' @return
#' @export
#'
#' @examples
available_datasets <- function(database, API_KEY) {
  available_databases(API_KEY)[name == database, location] |>
    get_schema(API_KEY)
}

#' Title
#'
#' @param database
#' @param dataset
#' @param API_KEY
#'
#' @return
#' @export
#'
#' @examples
available_fields <- function(database, dataset, API_KEY) {
  out <- available_datasets(database, API_KEY)[name == dataset, location] |>
    get_schema(API_KEY)

  out[, .(name, location = gsub("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema/", "", location))]
}
