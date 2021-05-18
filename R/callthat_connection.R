#' @export
callthat_connection <- function(url, ...) {
  structure(
    list(
      url = url
    ),
    class = "callthat_connection"
  )
}

setOldClass("callthat_connection")
