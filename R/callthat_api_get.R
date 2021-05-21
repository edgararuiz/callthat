#' @importFrom rlang enexprs enexpr
#' @importFrom httr add_headers

#' @export
callthat_api_get <- function(api_connection, endpoint, query = NULL, headers = list(),  eval_query = FALSE, ...) UseMethod("callthat_api_get")

#' @export
callthat_api_get.callthat_connection <- function(api_connection, endpoint, query = NULL,
                                                 headers = list(),  eval_query = FALSE, ...)  {
  vars <- enexprs(...)
  if(!eval_query) {
    qry <- enexpr(query)
  } else {
    qry <- query
  }
  url_path <- paste0(api_connection$url, "/",  endpoint)
  all_args <- c(url_path, vars, query = list(qry))
  r_safe(function() 1)
  r_safe(function(all_args)
    do.call(httr::GET, all_args),
    args = list(all_args = c(all_args, list(do.call(add_headers, headers))))
  )
}

#' @export
callthat_api_get.callthat_rsc_connection <- function(api_connection, endpoint, query = NULL,
                                                     headers = list(),  eval_query = FALSE, ...)  {

  url_path <- api_connection$url
  api_key <- api_connection$key

  if(!is.null(api_key)) headers <- c(headers, Authorization = paste0("Key ", api_key))

  ac <- callthat_connection(url_path)

  callthat_api_get(
    api_connection = ac,
    endpoint = endpoint,
    query = query,
    headers = headers,
    eval_query = TRUE
  )
}


#' @export
callthat_api_get.default <- function(...) {
  stop("No valid API connection object was passed to this function")
}
