#' Creates a connection object with an RStudio Connect server
#' @param url The URL address for the RStudio Connect server
#' @param key The personal authentication key created in the RStudio Connect server
#' @return A \code{call_that_connection} \ \code{call_that_rsc_connection} object
#' @export
call_that_rsc_connection <- function(url, key = NULL) {
  structure(
    list(
      url = url,
      key = key
    ),
    class = c("call_that_rsc_connection", "call_that_connection")
  )
}

setOldClass("call_that_rsc_connection")

#' @export
print.call_that_rsc_connection <- function(x, ...) {
  cat(paste0(
    "RStudio Connect API:  ", x$url,
    "\nAPI Key: ", ifelse(is.null(x$key), "None set", "XXXXXXXXXXXXXX")
  ))
}
