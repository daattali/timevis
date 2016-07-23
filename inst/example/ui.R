library(timevis)

fluidPage(
  "Demos of timevis",
  tabsetPanel(

    tabPanel(
      "More interacticity",
      br(),
      timevisOutput("timelineInteractive"),
      div(id = "interactiveActions",
        actionButton("fit", "Fit all items"),
        actionButton("setWindowAnim", "Set window from 2016-01-07 to 2016-01-25"),
        actionButton("setWindowNoAnim", "Set window from 2016-01-07 to 2016-01-25 without animation"),
        actionButton("center", "Center around 2016-01-23"),
        actionButton("focus2", "Focus item 4"),
        actionButton("focusSelection", "Focus current selection"),
        actionButton("addTime", "Add a draggable vertical bar on 2016-01-17")
      ),
      div(class = "optionsSection",
        uiOutput("selectIdsOutput", inline = TRUE),
        actionButton("selectItems", "Select"),
        checkboxInput("selectFocus", "Focus on selection", FALSE)
      ),
      div(class = "optionsSection",
        textInput("addText", "Add item:", "New item"),
        span("on"),
        dateInput("addDate", NULL, "2016-01-10"),
        actionButton("addBtn", "Add")
      ),
      div(class = "optionsSection",
        uiOutput("removeIdsOutput", inline = TRUE),
        actionButton("removeItem", "Remove")
      ),
      div("Selected items:", textOutput("selected", inline = TRUE)),
      div("Visible window:", textOutput("window", inline = TRUE)),
      tableOutput("table")
    ),
    tabPanel(
      "Basic timeline",
      br(),
      tags$link(href = "style.css", rel = "stylesheet"),
      timevisOutput("timelineBasic")
    ),

    tabPanel(
      "World Cup 2014",
      br(),
      timevisOutput("timelineWC")
    ),


    tabPanel(
      "Custom style and parameters",
      br(),
      timevisOutput("timelineCustom")
    )
  )
)
