#' @export
callthat_api_get <- function(api_connection, endpoint, query = NULL,
                             headers = list(), ...) {
  UseMethod("callthat_api_get")
}

#' @export
callthat_api_get.callthat_connection <- function(api_connection, endpoint, query = NULL,
                                                 headers = list(), ...)  {
  vars <- enexprs(...)
  url_path <- paste0(api_connection$url, "/",  endpoint)
  header_obj <- do.call(add_headers, headers)
  GET(
    url = url_path,
    query = query,
    header_obj,
    vars
  )
}

#' @export
callthat_api_get.callthat_rsc_connection <- function(api_connection, endpoint, query = NULL,
                                                     headers = list(), ...)  {

  vars <- enexpr(...)

  url_path <- api_connection$url
  api_key <- api_connection$key

  headers_obj <- headers

  if(!is.null(api_key)) headers_obj <- c(headers_obj, Authorization = paste0("Key ", api_key))

  ac <- callthat_connection(url_path)

  callthat_api_get(
    api_connection = ac,
    endpoint = endpoint,
    query = query,
    headers = headers_obj,
    vars
  )
}


#' @export
callthat_api_get.default <- function(...) {
  stop("No valid API connection object was passed to this function")
}
