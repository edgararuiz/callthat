#' @export
callthat_api_get <- function(api_connection, endpoint = "", query = NULL,
                             headers = list(), ...) {
  UseMethod("callthat_api_get")
}

#' @export
callthat_api_get.callthat_connection <- function(api_connection, endpoint = "", query = NULL,
                                                 headers = list(), ...)  {
  callthat_api(
    api_connection = api_connection,
    endpoint = endpoint,
    request = query,
    header = headers,
    action = "GET",
    ...
    )
}
