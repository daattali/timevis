library(shiny)
library(timelinevis)

ui <- fluidPage(

  timelinevisOutput("aaa"),actionButton("vv","vv"),actionButton("nnn","nnn"),
  timelinevisOutput("bbb", width = "50%")
)

server <- function(input, output, session) {
  output$aaa <- renderTimelinevis(timelinevis(
    myitems,
    listen = c("selected","window", "data")
  ))
  output$bbb <- renderTimelinevis(timelinevis(
    myitems2,showZoom = FALSE,
    options = list(editable=TRUE,clickToUse=T),
    listen=c("a","bb")))
observeEvent(input$vv, {
  addItem("aaa", list(id = "6", title="fff",content="AAAA", start="2013-04-08"))
  addItems("aaa", data.frame(id=8:9,content=c("vvvv","zzxc"),start=c("2013-05-10","2013-03-03")))
  removeItem("bbb", 2)
  addCustomTime("aaa", itemId = "fff")
  addCustomTime("aaa", "2013-04-10", itemId = as.character(as.integer(Sys.time())))
})
observeEvent(input$nnn, {
  setWindow("aaa", "2016-07-08", "2019-04-04")
})
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
