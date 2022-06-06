#' Start a statxplore query
#'
#' @param database The name of the database
#' @param dataset The name of the dataset
#' @param API_KEY Your statxplore account API key
#'
#' @return
#' @export
#'
#' @examples
start_query <- function(database, dataset, API_KEY) {
  db_url <- available_databases(API_KEY)[name == database, location]

  ds_url <- available_datasets(database, API_KEY)[name == dataset, location]

  out <- list(database = list(name = database, url = db_url),
              dataset = list(name = dataset, url = ds_url),
              measure = NULL,
              fields = NULL,
              API_KEY = API_KEY)

  class(out) <- "statx_query"

  return(out)
}

#' Add the measurement variable to the query
#'
#' @param query An object created by start_query
#' @param measure The name of the measure
#' @param rename Optional. What should the measure variable returned in the data.frame be called
#'
#' @return
#' @export
#'
#' @examples
add_measure <- function(query, measure, rename = NULL) {
  measure_locat <- available_fields(query$database$name, query$dataset$name, query$API_KEY)[name == measure, location]
  query$measure$to_send <- paste0('"', measure_locat, '"')

  if (is.null(rename)) {
    query$measure$name <- measure
  } else {
    query$measure$name <- rename
  }
  return(query)
}

#' Add the query fields
#'
#' @param query An object created by start_query
#' @param fields The names of the fields
#' @param rename Optional. What should the field variables returned in the data.frame be called
#'
#' @return
#' @export
#'
#' @examples
add_fields <- function(query, fields, rename = NULL) {
  field_locats <- available_fields(query$database$name, query$dataset$name, query$API_KEY)[name %in% fields, location]

  query$fields$to_send <- paste0("[ ", '"', field_locats, '"', " ]", collapse = ", ")

  if (is.null(rename)) {
    query$fields$names <- fields
  } else {
    query$fields$names <- rename
  }

  return(query)
}

#' Return the dataset from the query
#'
#' @param query An object created using start_query
#'
#' @return
#' @export
#'
#' @examples
fetch <- function(query) {
  db_location <- query$database$url
  ds_name <- gsub("https://stat-xplore.dwp.gov.uk/webapi/rest/v1/schema/", "", query$dataset$url)
  measures <- query$measure$to_send
  dimensions <- query$fields$to_send


  to_send <- glue::glue(
    '
  "database" : "{ds_name}",
  "measures" : [ {measures} ],
  "dimensions" : [{dimensions}]
  '
  )

  if (send) {
    result <- paste0("{", to_send, "}") |>
      fetch_data(names = c(query$fields$names, query$measure$name), API_KEY)

    return(janitor::clean_names(result))
  } else {
    return(paste0("{", to_send, "}"))
  }
}
