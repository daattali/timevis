library(shiny)

ui <- fluidPage(
  timelinevisOutput("aaa"),
  timelinevisOutput("bbb", width = "50%")
)

server <- function(input, output, session) {
  output$aaa <- renderTimelinevis(timelinevis(myitems))
  output$bbb <- renderTimelinevis(timelinevis(myitems2, showZoom = FALSE))

  #updateTimelinevis("aaa")
}

runApp(shinyApp(ui = ui, server = server), port = 4468)
