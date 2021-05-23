#' Submits a PUT command against a REST API
#' @param api_connection A \code{callthat_connection} object
#' @param endpoint The name of the API's endpoint.  Defaults to an empty character vector.
#' @param body The body or query sent to the REST API.
#' @param headers A \code{list} object containing a named list of headers to pass to the API.
#' @param ... Other arguments to pass to the REST API call.
#' @return An \code{httr} \code{request} object
#' @export
callthat_api_put <- function(api_connection, endpoint = "", body = NULL,
                             headers = list(), ...) {
  UseMethod("callthat_api_put")
}

#' @export
callthat_api_put.callthat_connection <- function(api_connection, endpoint = "", body = NULL,
                                                 headers = list(), ...)  {
  callthat_api(
    api_connection = api_connection,
    endpoint = endpoint,
    request = body,
    headers = headers,
    action = "PUT",
    ...
  )
}
