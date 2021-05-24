
<!-- README.md is generated from README.Rmd. Please edit that file -->

# callthat

<!-- badges: start -->

[![R-CMD-check](https://github.com/edgararuiz/callthat/workflows/R-CMD-check/badge.svg)](https://github.com/edgararuiz/callthat/actions)
[![Codecov test
coverage](https://codecov.io/gh/edgararuiz/callthat/branch/master/graph/badge.svg)](https://codecov.io/gh/edgararuiz/callthat?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`callthat` is meant for `plumber` API developers who plan to distribute
their APIs inside an R package. This package enables the testing of the
API’s endpoints within the `testthat` framework. This allows the R
Checks to also confirm that the endpoints still behave as expected. The
ultimate goal of `callthat` is to ensure for the package’s automated
testing confirms that the APIs still work even if the developer did not
run the package’s test locally.

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edgararuiz/callthat")
```

## Usage

### Local

``` r
library(callthat)

my_api <- callthat_plumber_start()
#> 
#> Starting callthat's sample API

my_api
#> API is running on http://127.0.0.1:6556 inside an R session on PID 1868
#> Swagger page: http://127.0.0.1:6556/__docs__/
```

``` r
callthat_api_get(my_api, "data") 
#> Response [http://127.0.0.1:6556/data]
#>   Date: 2021-05-24 14:18
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB
```

``` r
callthat_api_put(my_api, "predict", body = list(weight = 2), encode = "json") 
#> Response [http://127.0.0.1:6556/predict]
#>   Date: 2021-05-24 14:18
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 9 B
```

``` r
callthat_api_post(my_api, "predict", body = list(weight = 2), encode = "json") 
#> Response [http://127.0.0.1:6556/predict]
#>   Date: 2021-05-24 14:18
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 9 B
```

### Using inside `testthat`

``` r
library(testthat)
library(httr)

test_that("data endpoint works", {
  test_api <- callthat_plumber_start(port = 9999)
  get_data <- callthat_api_get(test_api, "data") 
  # Test that the request was sucessfull
  expect_equal(get_data$status_code, 200)
  # Confirm that the content of the response is as expected 
  expect_equal(names(content(get_data)[[1]])[1], "mpg")
  callthat_plumber_stop(test_api)
})
```

### RStudio Connect

``` r
rsc_api <- callthat_rsc_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

rsc_api
#> RStudio Connect API:  https://colorado.rstudio.com/rsc/access-to-care/api
#> API Key: None set
```

``` r
callthat_api_get(rsc_api, "summary", list("state" = "CA")) 
#> Response [https://colorado.rstudio.com/rsc/access-to-care/api/summary?state=CA]
#>   Date: 2021-05-24 14:18
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 111 B
```

### Secured API inside RStudio Connect

``` r
secured_api <- callthat_rsc_connection(url = "https://colorado.rstudio.com/rsc/callthat/testapi",
                                       key = Sys.getenv("CONNECT_API_KEY"))

secured_api
#> RStudio Connect API:  https://colorado.rstudio.com/rsc/callthat/testapi
#> API Key: XXXXXXXXXXXXXX
```

``` r
callthat_api_get(secured_api, "data") 
#> Response [https://colorado.rstudio.com/rsc/callthat/testapi/data]
#>   Date: 2021-05-24 14:18
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB
```

``` r
callthat_api_post(secured_api, "sum", list(a = 2, b = 2), encode = "json")
#> Response [https://colorado.rstudio.com/rsc/callthat/testapi/sum]
#>   Date: 2021-05-24 14:18
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 3 B
```

### Generic connection

``` r
generic_api <- callthat_connection("http://httpbin.org")

generic_api
#> Connection to API located in: http://httpbin.org
```

``` r
callthat_api_post(generic_api, endpoint = "post", body = "A simple text")
#> Response [http://httpbin.org/post]
#>   Date: 2021-05-24 14:18
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 472 B
#> {
#>   "args": {}, 
#>   "data": "A simple text", 
#>   "files": {}, 
#>   "form": {}, 
#>   "headers": {
#>     "Accept": "application/json, text/xml, application/xml, */*", 
#>     "Accept-Encoding": "deflate, gzip", 
#>     "Content-Length": "13", 
#>     "Host": "httpbin.org", 
#> ...
```
