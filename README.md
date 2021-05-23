
<!-- README.md is generated from README.Rmd. Please edit that file -->

# callthat

<!-- badges: start -->
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

``` r
library(magrittr)
library(httr)
```

### Local

``` r
library(callthat)

my_api <- callthat_plumber_start()
#> [1] "Starting callthat's sample API"
```

``` r
my_api %>% 
  callthat_api_get("data") 
#> Response [http://127.0.0.1:6556/data]
#>   Date: 2021-05-23 15:47
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB
```

``` r
my_api %>% 
  callthat_api_get("predict", query = list(weight = 2)) 
#> Response [http://127.0.0.1:6556/predict?weight=2]
#>   Date: 2021-05-23 15:47
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 9 B
```

``` r
my_api %>% 
  callthat_api_post("predict", body = list(weight = 2)) 
#> Response [http://127.0.0.1:6556/predict]
#>   Date: 2021-05-23 15:47
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 2 B
```

### RStudio Connect

``` r
rsc_api <- callthat_rsc_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

rsc_api
#> RStudio Connect API:  https://colorado.rstudio.com/rsc/access-to-care/api
#> API Key: None set
```

``` r
rsc_api %>% 
  callthat_api_get("summary", list("state" = "CA")) %>% 
  content()
#> [[1]]
#> [[1]]$state
#> [1] "CA"
#> 
#> [[1]]$hospitals
#> [1] 323
#> 
#> [[1]]$population
#> [1] 39144818
#> 
#> [[1]]$under
#> [1] 4
#> 
#> [[1]]$counties
#> [1] 58
#> 
#> [[1]]$state_id
#> [1] 5
#> 
#> [[1]]$full
#> [1] "California"
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
#>   Date: 2021-05-23 15:47
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB
```

``` r
callthat_api_post(secured_api, "sum", list(a = 2, b = 2)) %>% 
  content("parsed")
#> list()
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
#>   Date: 2021-05-23 15:47
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

``` r
remote_api <- callthat_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

remote_api
#> Connection to API located in: https://colorado.rstudio.com/rsc/access-to-care/api
```

``` r
la_summary <- callthat_api_get(remote_api, "summary", list("state" = "LA"))

httr::content(la_summary)
#> [[1]]
#> [[1]]$state
#> [1] "LA"
#> 
#> [[1]]$hospitals
#> [1] 90
#> 
#> [[1]]$population
#> [1] 4670724
#> 
#> [[1]]$under
#> [1] 1
#> 
#> [[1]]$counties
#> [1] 64
#> 
#> [[1]]$state_id
#> [1] 19
#> 
#> [[1]]$full
#> [1] "Louisiana"
```
