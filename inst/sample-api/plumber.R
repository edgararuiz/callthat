library(plumber)
# Notice that I'm loading the packagedapis package,
# this means that the package needs to be Installed
# before testing the API
library(packagedapis)

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
