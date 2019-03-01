library(plumber)

pr <- plumb("plumber.R")

pr$run(host="159.65.105.240", port=4000)