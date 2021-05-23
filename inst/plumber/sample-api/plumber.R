library(plumber)

#* Returns mtcars data
#* @get /data
function() {
  datasets::mtcars
}

#* Runs a prediction of the Weight
#* @get /predict
#* @post / predict
#* @put /predict
#* @param weight: Vector with car weights
function(weight) {
  wtg <- as.numeric(weight)
  model <- stats::lm(mpg ~ wt, data = datasets::mtcars)
  stats::predict(model, newdata = data.frame(wt = wtg))
}
