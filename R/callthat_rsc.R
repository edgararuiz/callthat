#' Creates a connection object with an RStudio Connect server
#' @param url The URL address for the RStudio Connect server
#' @param key The personal authentication key created in the RStudio Connect server
#' @return A \code{callthat_connection} \ \code{callthat_rsc_connection} object
#' @export
callthat_rsc_connection <- function(url, key = NULL) {
  structure(
    list(
      url = url,
      key = key
    ),
    class = c("callthat_rsc_connection", "callthat_connection")
  )
}

setOldClass("callthat_rsc_connection")

#' @export
print.callthat_rsc_connection <- function(x, ...) {
  cat(paste0(
    "RStudio Connect API:  ", x$url,
    "\nAPI Key: ", ifelse(is.null(x$key), "None set", "XXXXXXXXXXXXXX")
  ))
}

