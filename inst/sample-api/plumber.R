library(plumber)

show_data <- function() {
  datasets::mtcars
}

show_model <- function() {
  model <- stats::lm(mpg ~ wt, data = datasets::mtcars)
  summary(model)$coefficients
}

get_prediction <- function(x) {
  model <- stats::lm(mpg ~ wt, data = datasets::mtcars)
  stats::predict(model, newdata = data.frame(wt = x))
}

#* Returns mtcars data
#* @get /data
function() {
  show_data()
}

#* Returns the summary of the model
#* @get /model
function() {
  show_model()
}

#* Runs a prediction of the Weight
#* @get /predict
#* @param weight: Vector with car weights
function(weight) {
  get_prediction(as.numeric(weight))
}
