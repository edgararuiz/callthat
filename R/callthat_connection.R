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
