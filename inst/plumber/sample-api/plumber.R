library(plumber)

#* Returns mtcars data
#* @get /data
function() {
  datasets::mtcars
}

#* Runs a prediction of the Weight
#* @get /predict
#* @post /predict
#* @put /predict
#* @param weight: Vector with car weights
function(weight) {
  wtg <- as.numeric(weight)
  model <- stats::lm(mpg ~ wt, data = datasets::mtcars)
  stats::predict(model, newdata = data.frame(wt = wtg))
}

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}
