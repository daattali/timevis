library(shiny)
library(timelinevis)

ui <- fluidPage(
  timelinevisOutput("aaa"),
  timelinevisOutput("bbb", width = "50%")
)

server <- function(input, output, session) {
  output$aaa <- renderTimelinevis(timelinevis(
    myitems,
    editable = TRUE,
    multiselect=TRUE,
    listen = c("selected","window", "data")
  ))
  output$bbb <- renderTimelinevis(timelinevis(myitems2,showZoom = FALSE,
                                              listen=c("a","bb")))

  observe({
    cat(input$aaa_selected, "\n")
  })

  observe({
    cat(input$aaa_window,"\n")
  })


  observe({

    cat(str(input$aaa_data),"\n")
  })

  #updateTimelinevis("aaa")
}

runApp(shinyApp(ui = ui, server = server), port = 4468)
