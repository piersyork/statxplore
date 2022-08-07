### Define global variables
globalVariables(c("name", "location", ".", "API_KEY"))


#' Internal function to get the schema at an endpoint
#'
#' @param url The endpoint url
#'
#' @return a dataframe of the schema
#' @export
#'
#'
get_schema <- function(url) {
  response <- httr::GET(url, httr::add_headers(APIKey = get_api_key()))

  children <- httr::content(response)$children

  children |>
    lapply(\(x) data.table::data.table(name = x$label, location = x$location)) |>
    dplyr::bind_rows()
}

#' Internal function to get the query name of the measure/field
#'
#' @param schema The dataset scheme
#' @param field The field of interest
#'
#' @return A query name of the field
#' @noMd
#'
get_data_locat <- function(schema, field) {
  schema[name == field, gsub("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema/", "", location)]
}

#' Internal function to send the post request for the dataset
#'
#' @description Intended to be used internally but can be used to send a custom statXplore query
#'
#' @param query The query object
#' @param names new column names
#'
#' @return the parsed json of the data
#' @export
#'
fetch_data <- function(query, names = NULL) {
  response <- httr::POST(url = "https://stat-xplore.dwp.gov.uk/webapi/rest/v1/table",
                         httr::add_headers(APIKey = get_api_key()), body = query) |>
    httr::content()

  items <- lapply(response$fields, \(x) unlist(lapply(x$items, \(y) y$labels)))

  df <- do.call(tidyr::expand_grid, items)
  values <- unlist(response$cubes[[1]][[1]])

  df$values <- values

  if (!is.null(names)) {
    colnames(df) <- names
  }

  return(df)
}
