#' @export
callthat_api_get <- function(api_session, endpoint, query = NULL, ...) UseMethod("callthat_api_get")

#' @export
callthat_api_get.callthat_local_api <- function(api_session, endpoint, query = NULL, ...)  {
  url_path <- paste0("http://127.0.0.1:", api_session$port)
  r_safe(function() 1)
  r_safe(function(ur, enp, qry)
    httr::GET(url = ur, path = enp, query = qry),
    args = list(ur = url_path, enp = endpoint, qry = query)
  )
}

#' @export
callthat_api_get.default <- function(...) {
  stop("No valid API connection object was passed to this function")
}

