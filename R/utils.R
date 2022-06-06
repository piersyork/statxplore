#' Title
#'
#' @param url
#' @param API_KEY
#'
#' @return
#' @export
#'
#'
#' @examples
get_schema <- function(url, API_KEY) {
  response <- httr::GET(url, httr::add_headers(APIKey = API_KEY))

  children <- httr::content(response)$children

  children |>
    lapply(\(x) data.table(name = x$label, location = x$location)) |>
    dplyr::bind_rows()
}

#' Title
#'
#' @param schema
#' @param field
#'
#' @return
#' @export
#'
#' @examples
get_data_locat <- function(schema, field) {
  schema[name == field, gsub("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema/", "", location)]
}

#' Title
#'
#' @param query
#' @param names
#' @param API_KEY
#'
#' @return
#' @export
#'
#' @examples
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
