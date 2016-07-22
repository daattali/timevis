library(timelinevis)

fluidPage(
  "Demos of timelinevis",
  tabsetPanel(
    tabPanel(
      "World Cup 2014",
      br(),
      timelinevisOutput("timelineWC")
    ),

    tabPanel(
      "Basic timeline",
      br(),
      tags$link(href = "style.css", rel = "stylesheet"),
      timelinevisOutput("timelineBasic")
    ),

    tabPanel(
      "Fully interactive timeline",
      br(),
      "interactive"
    ),

    tabPanel(
      "Custom style and parameters",
      br(),
      timelinevisOutput("timelineCustom")
    )
  )
)
