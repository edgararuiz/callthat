#' Creates a generic API connection object
#' @param url The API's URL address
#' @param ... Available to allow backwards compatability in case more arguments are implemented in later versions of this package. Not in use today.
#' @return A \code{call_that_connection} object
#' @export
call_that_connection <- function(url, ...) {
  structure(
    list(
      url = url
    ),
    class = "call_that_connection"
  )
}

setOldClass("call_that_connection")

#' @export
print.call_that_connection <- function(x, ...) {
  cat(
    paste0("Connection to API located in: ", x$url)
  )
}
