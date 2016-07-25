library(timevis)

fluidPage(
  div(id = "header",
    div(id = "title",
      "timevis"
    ),
    div(id = "subtitle",
        "An R package for creating timeline visualizations"),
    div(id = "subsubtitle",
        "Created by",
        tags$a(href = "http://deanattali.com/", "Dean Attali"),
        HTML("&bull;"),
        "Package & example code",
        tags$a(href = "https://github.com/daattali/timevis", "on GitHub")
    )
  ),
  tabsetPanel(
    tabPanel(
      div(icon("calendar"), "Basic timeline"),
      br(),
      tags$link(href = "style.css", rel = "stylesheet"),
      timevisOutput("timelineBasic")
    ),

    tabPanel(
      div(icon("cog"), "Custom style and parameters"),
      br(),
      timevisOutput("timelineCustom")
    ),

    tabPanel(
      div(icon("trophy"), "World Cup 2014"),
      br(),
      timevisOutput("timelineWC")
    ),

    tabPanel(
      div(icon("sliders"), "Fully interactive"),
      br(),
      fluidRow(
        column(8,
               timevisOutput("timelineInteractive")
        ),
        column(4,
           div(
             id = "timelinedata",
             class = "optionsSection",
             tableOutput("table"),
             hr(),
             div("Visible window:", textOutput("window", inline = TRUE)),
             div("Selected items:", textOutput("selected", inline = TRUE))
           )
        )
      ),
      fluidRow(column(3,
        div(id = "interactiveActions",
          class = "optionsSection",
          tags$h4("Actions:"),
          actionButton("fit", "Fit all items"),
          actionButton("setWindowAnim", "Set window 2016-01-07 to 2016-01-25"),
          actionButton("setWindowNoAnim", "Set window without animation"),
          actionButton("center", "Center around 2016-01-23"),
          actionButton("focus2", "Focus item 4"),
          actionButton("focusSelection", "Focus current selection"),
          actionButton("addTime", "Add a draggable vertical bar 2016-01-17")
      )),column(3,
        div(class = "optionsSection",
          uiOutput("selectIdsOutput", inline = TRUE),
          actionButton("selectItems", "Select"),
          checkboxInput("selectFocus", "Focus on selection", FALSE)
      )),column(3,
        div(class = "optionsSection",
          textInput("addText", tags$h4("Add item:"), "New item"),
          dateInput("addDate", NULL, "2016-01-15"),
          actionButton("addBtn", "Add")
      )),column(3,
        div(class = "optionsSection",
          uiOutput("removeIdsOutput", inline = TRUE),
          actionButton("removeItem", "Remove")
      )))
    )
  )
)
