#devtools::install_github("rstudio/crosstalk")
library(crosstalk)
library(timevis)

sd <- SharedData$new(
  data.frame(
    id = 1:2,
    content = c("one", "two"),
    start = c("2016-01-10", "2016-01-12")
  )
)

timevis(sd)
