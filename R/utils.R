### Define global variables
globalVariables(c("name", "location", ".", "API_KEY"))


#' Internal function to get the schema at an endpoint
#'
#' @param url The endpoint url
#' @param API_KEY Your account API key
#'
#' @return a dataframe of the schema
#' @noMd
#'
#'
get_schema <- function(url, API_KEY) {
  response <- httr::GET(url, httr::add_headers(APIKey = API_KEY))

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
#' @param query The query object
#' @param names new column names
#' @param API_KEY Your account API key
#'
#' @return the parsed json of the data
#' @noMd
#'
fetch_data <- function(query, names, API_KEY) {
  response <- httr::POST(url = "https://stat-xplore.dwp.gov.uk/webapi/rest/v1/table", httr::add_headers(APIKey = API_KEY), body = query) |>
    httr::content()

  items <- lapply(response$fields, \(x) unlist(lapply(x$items, \(y) y$labels)))

  df <- do.call(tidyr::expand_grid, items)
  values <- unlist(response$cubes[[1]][[1]])

  df$values <- values

  colnames(df) <- names

  return(df)
}
