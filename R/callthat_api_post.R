#' @export
callthat_api_post <- function(api_connection, endpoint, body = NULL,
                             headers = list(), ...) {
  UseMethod("callthat_api_post")
}

#' @export
callthat_api_post.callthat_connection <- function(api_connection, endpoint, body = NULL,
                                                 headers = list(), ...)  {
  callthat_api(
    api_connection = api_connection,
    endpoint = endpoint,
    request = body,
    header = headers,
    action = "POST",
    ...
  )
}
