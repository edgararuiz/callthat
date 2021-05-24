#' Generic function to make API calls
#' @details It provides a single interface to perform the different calls to an API, such as GET or
#' POST.  This function is meant to be used by developers who which to extend \code{callthat} to
#' integrate with other API server types.
#'
#' @param api_connection A \code{call_that_connection} object.
#' @param endpoint A character variable with containing the endpoint's name.
#' @param request The body or query sent to the REST API.
#' @param headers A \code{list} object containing a named list of headers to pass to the API.
#' @param action The action to request from the API. Supported today are: GET, POST and PUT.
#' @param ... Other arguments to pass to the REST API call.
#' @export
call_that_api <- function(api_connection, endpoint, request = NULL,
                          headers = list(), action = c("GET", "POST", "PUT"), ...) {
  UseMethod("call_that_api")
}

#' @export
call_that_api.call_that_connection <- function(api_connection, endpoint, request = NULL,
                                               headers = list(), action = c("GET", "POST", "PUT"), ...) {
  api_call(
    api_connection = api_connection,
    endpoint = endpoint,
    request = request,
    headers = headers,
    action = action,
    ...
  )
}

#' @export
call_that_api.call_that_rsc_connection <- function(api_connection, endpoint, request = NULL,
                                                   headers = list(), action = c("GET", "POST", "PUT"), ...) {
  api_key <- api_connection$key
  if (!is.null(api_key)) headers <- c(headers, Authorization = paste0("Key ", api_key))

  api_call(
    api_connection = api_connection,
    endpoint = endpoint,
    request = request,
    headers = headers,
    action = action,
    ...
  )
}

api_call <- function(api_connection, endpoint, request = NULL,
                     headers = list(), action = c("GET", "POST", "PUT"), ...) {
  url_path <- paste0(api_connection$url, "/", endpoint)
  header_obj <- do.call(add_headers, headers)
  rest <- NULL
  if (action == "GET") res <- GET(url = url_path, query = request, header_obj, ...)
  if (action == "PUT") res <- PUT(url = url_path, body = request, header_obj, ...)
  if (action == "POST") res <- POST(url = url_path, body = request, header_obj, ...)
  res
}
