library(timelinevis)

source("sampleData.R")

function(input, output, session) {
  output$timelineBasic <- renderTimelinevis({
    timelinevis(dataBasic)
  })

  output$timelineWC <- renderTimelinevis({
    timelinevis(dataWC)
  })

  output$timelineCustom <- renderTimelinevis({
    config <- list(
      editable = TRUE,
      align = "right",
      orientation = "top",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )
    timelinevis(dataBasic, options = config)
  })
}
