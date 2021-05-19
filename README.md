
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

### Local

``` r
library(callthat)

my_api <- callthat_local_start()
#> [1] "Starting callthat's sample API"

my_api
#> API is running on http://127.0.0.1:6556 inside an R session on PID 55754
#> Swagger page: http://127.0.0.1:6556/__docs__/

class(my_api)
#> [1] "callthat_local_connection" "callthat_connection"

callthat_local_running(my_api)
#> [1] TRUE

callthat_api_get(my_api, "data")
#> Response [http://127.0.0.1:6556/data]
#>   Date: 2021-05-19 14:55
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 4.15 kB
```

### RStudio Connect

``` r
rsc_api <- callthat_rsc_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

rsc_api
#> RStudio Connect API:  https://colorado.rstudio.com/rsc/access-to-care/api
#> API Key: None set
```

``` r
callthat_api_get(rsc_api, "summary", list("state" = "LA"))
#> Response [https://colorado.rstudio.com/rsc/access-to-care/api/summary?state=LA]
#>   Date: 2021-05-19 14:55
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 109 B
```

### Generic connection

``` r
remote_api <- callthat_connection("https://colorado.rstudio.com/rsc/access-to-care/api")

remote_api
#> Connection to API located in: https://colorado.rstudio.com/rsc/access-to-care/api

callthat_api_get(remote_api, "summary", list("state" = "LA"))
#> Response [https://colorado.rstudio.com/rsc/access-to-care/api/summary?state=LA]
#>   Date: 2021-05-19 14:55
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 109 B
```
