#' @export
callthat_api_put <- function(api_connection, endpoint, body = NULL,
                             headers = list(), ...) {
  UseMethod("callthat_api_put")
}

#' @export
callthat_api_put.callthat_connection <- function(api_connection, endpoint, body = NULL,
                                                 headers = list(), ...)  {
  callthat_api(
    api_connection = api_connection,
    endpoint = endpoint,
    request = body,
    header = headers,
    action = "PUT",
    ...
  )
}
