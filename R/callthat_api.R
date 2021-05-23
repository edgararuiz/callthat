#' @export
callthat_api <- function(api_connection, endpoint, request = NULL,
                         headers = list(), action = c("GET", "POST", "PUT"), ...) {
  UseMethod("callthat_api")
}

#' @export
callthat_api.callthat_connection <- function(api_connection, endpoint, request = NULL,
                                             headers = list(), action = c("GET", "POST", "PUT"), ...) {
  api_call(
    api_connection = api_connection,
    endpoint = endpoint,
    request = request,
    header = headers,
    action = action,
    ...
  )
}

#' @export
callthat_api.callthat_rsc_connection <- function(api_connection, endpoint, request = NULL,
                                             headers = list(), action = c("GET", "POST", "PUT"), ...) {
  api_key <- api_connection$key
  if(!is.null(api_key)) headers <- c(headers, Authorization = paste0("Key ", api_key))

  api_call(
    api_connection = api_connection,
    endpoint = endpoint,
    request = request,
    header = headers,
    action = action,
    ...
  )
}

#' @export
callthat_api.default <- function(...) {
  stop("No valid API connection object was passed to this function")
}

api_call <- function(api_connection, endpoint, request = NULL,
                     headers = list(), action = c("GET", "POST", "PUT"), ...) {
  url_path <- paste0(api_connection$url, "/",  endpoint)
  header_obj <- do.call(add_headers, headers)
  rest <- NULL
  if(action == "GET")  res <- GET(url = url_path, query = request, header_obj, ...)
  if(action == "PUT")  res <- PUT(url = url_path, body = request, header_obj, ...)
  if(action == "POST") res <- POST(url = url_path, body = request, header_obj, ...)
  res
}
