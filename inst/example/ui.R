library(timelinevis)

fluidPage(
  "Demos of timelinevis",
  tabsetPanel(

    tabPanel(
      "More interacticity",
      br(),
      timelinevisOutput("timelineInteractive"),
      actionButton("fit", "Fit all items"),
      actionButton("setWindowAnim", "Set window from 2016-01-07 to 2016-01-25"),
      actionButton("setWindowNoAnim", "Set window from 2016-01-07 to 2016-01-25 without animation"),
      actionButton("center", "Center around 2016-01-23"),
      actionButton("focus2", "Focus item 4"),
      actionButton("focusSelection", "Focus current selection"),
      span("Select items:"),
      uiOutput("selectIdsOutput"),
      actionButton("selectItems", "Select"),
      checkboxInput("selectFocus", "Focus on selection", FALSE),
      span("Add item:"),
      textInput("addText", NULL, "New item"),
      span("on"),
      dateInput("addDate", NULL, "2016-01-10"),
      actionButton("addBtn", "Add"),
      span("Remove item:"),
      uiOutput("removeIdsOutput"),
      actionButton("removeItem", "Remove"),
      actionButton("addTime", "Add a draggable vertical bar on 2016-01-17"),
      div("Selected items:", textOutput("selected", inline = TRUE)),
      div("Visible window:", textOutput("window", inline = TRUE)),
      tableOutput("table")
    ),
    tabPanel(
      "Basic timeline",
      br(),
      tags$link(href = "style.css", rel = "stylesheet"),
      timelinevisOutput("timelineBasic")
    ),

    tabPanel(
      "World Cup 2014",
      br(),
      timelinevisOutput("timelineWC")
    ),


    tabPanel(
      "Custom style and parameters",
      br(),
      timelinevisOutput("timelineCustom")
    )
  )
)
