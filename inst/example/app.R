library(shiny)
library(timelinevis)

dataBasic <- data.frame(
  id = 1:4,
  content = c("Item one", "Item two" ,"Ranged item", "Item four"),
  start   = c("2016-01-10", "2016-01-11", "2016-01-20", "2016-02-14"),
  end    = c(NA, NA, "2016-02-04", NA)
)

ui <- fluidPage(
  "Demos of timelinevis",
  tabsetPanel(
    tabPanel(
      "Basic timeline",
      br(),
      timelinevisOutput("timelineBasic")
    ),

    tabPanel(
      "Fully interactive timeline",
      br(),
      "interactive"
    ),

    tabPanel(
      "Custom style and more customization"
    )
  )
)

server <- function(input, output, session) {
  output$timelineBasic <- renderTimelinevis(
    timelinevis(basicData)
  )
}

shinyApp(ui = ui, server = server)
