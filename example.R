library(shiny)

ui <- fluidPage(
  timelinevisOutput("aaa"),
  timelinevisOutput("bbb", width = "50%")
)

server <- function(input, output, session) {
  output$aaa <- renderTimelinevis(timelinevis(myitems))
  output$bbb <- renderTimelinevis(timelinevis(myitems2))

  #updateTimelinevis("aaa")
}

shinyApp(ui = ui, server = server)
