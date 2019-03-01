library(plumber)

pr <- plumb("C:/users/kelse/Desktop/Rscripts/APITEST/plumber.R")

pr$run(port=8080)