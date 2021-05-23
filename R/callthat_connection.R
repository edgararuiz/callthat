#' Creates a generic API connection object
#' @param url The API's URL address
#' @param ... Available to allow backwards compatability in case more arguments are implemented in later versions of this package. Not in use today.
#' @return A \code{callthat_connection} object
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

#' @export
print.callthat_connection <- function(x, ...) {
  cat(
    paste0("Connection to API located in: ", x$url)
  )
}
