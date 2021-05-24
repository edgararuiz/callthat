#' Submits a POST command against a REST API
#' @param api_connection A \code{call_that_connection} object
#' @param endpoint The name of the API's endpoint.  Defaults to an empty character vector.
#' @param body The body or query sent to the REST API.
#' @param headers A \code{list} object containing a named list of headers to pass to the API.
#' @param ... Other arguments to pass to the REST API call.
#' @return An \code{httr} \code{request} object
#' @export
call_that_api_post <- function(api_connection, endpoint = "", body = NULL,
                               headers = list(), ...) {
  UseMethod("call_that_api_post")
}

#' @export
call_that_api_post.call_that_connection <- function(api_connection, endpoint = "", body = NULL,
                                                    headers = list(), ...) {
  call_that_api(
    api_connection = api_connection,
    endpoint = endpoint,
    request = body,
    headers = headers,
    action = "POST",
    ...
  )
}
