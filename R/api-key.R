statx_cache <- new.env()
API_KEY <- "API_KEY"

#' Set the API Key
#'
#' @param key Your statXplore API Key, available from your statXplore account info
#'
#' @return No return, assigns the API to cache
#'
#' @export
#'
#' @examples
#' set_api_key("YOUR_API_KEY")
#'
#'

set_api_key <- function(key) {
  assign(API_KEY, key, envir = statx_cache)
}

#' Get the API Key
#'
#' @return The API key stored in cache
#' @export
#'
#' @examples
#' api_key <- get_api_key()
#'

get_api_key <- function() {
  get(API_KEY, envir = statx_cache)
}
