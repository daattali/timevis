library(timevis)

codeConsole <-
'library(timevis)

data <- data.frame(
  id      = 1:4,
  content = c("Item one", "Item two",
              "Ranged item", "Item four"),
  start   = c("2016-01-10", "2016-01-11",
              "2016-01-20", "2016-02-14 15:00:00"),
  end     = c(NA, NA, "2016-02-04", NA)
)

timevis(data)'

codeShiny <-
'library(shiny)
library(timevis)

data <- data.frame(
  id      = 1:4,
  content = c("Item one", "Item two",
              "Ranged item", "Item four"),
  start   = c("2016-01-10", "2016-01-11",
              "2016-01-20", "2016-02-14 15:00:00"),
  end     = c(NA, NA, "2016-02-04", NA)
)

ui <- fluidPage(
  timevisOutput("timeline")
)

server <- function(input, output, session) {
  output$timeline <- renderTimevis({
    timevis(data)
  })
}

shinyApp(ui = ui, server = server)
'

fluidPage(
  title = "timevis - An R package for creating timeline visualizations",
  tags$link(href = "style.css", rel = "stylesheet"),
  div(id = "header",
    div(id = "title",
      "timevis"
    ),
    div(id = "subtitle",
        "An R package for creating timeline visualizations"),
    div(id = "subsubtitle",
        "By",
        tags$a(href = "http://deanattali.com/", "Dean Attali"),
        HTML("&bull;"),
        "Package & examples",
        tags$a(href = "https://github.com/daattali/timevis", "on GitHub"),
        HTML("&bull;"),
        tags$a(href = "http://daattali.com/shiny/", "More apps"), "by Dean"
    )
  ),
  tabsetPanel(
    tabPanel(
      div(icon("calendar"), "Basic timeline"),
      timevisOutput("timelineBasic"),
      div(
        id = "samplecode",
        fluidRow(
          column(
            6,
            div(class = "codeformat",
              "In R console or interactive R markdown documents"),
            tags$pre(codeConsole)
          ),
          column(
            6,
            div(class = "codeformat",
                "In Shiny apps"),
            tags$pre(codeShiny)
          )
        )
      ),
      div(class = "sourcecode",
        "The exact code for all the timelines in this app is",
        tags$a(href = "https://github.com/daattali/timevis/tree/master/inst/example",
               "on GitHub")
      )
    ),

    tabPanel(
      div(icon("cog"), "Custom style and parameters"),
      timevisOutput("timelineCustom"),
      div(class = "sourcecode",
          "The exact code for all the timelines in this app is",
          tags$a(href = "https://github.com/daattali/timevis/tree/master/inst/example",
                 "on GitHub")
      )
    ),

    tabPanel(
      div(icon("trophy"), "World Cup 2014"),
      timevisOutput("timelineWC"),
      div(class = "sourcecode",
          "The exact code for all the timelines in this app is",
          tags$a(href = "https://github.com/daattali/timevis/tree/master/inst/example",
                 "on GitHub")
      )
    ),

    tabPanel(
      div(icon("sliders"), "Fully interactive"),
      fluidRow(
        column(
          8,
          fluidRow(column(12,
            timevisOutput("timelineInteractive")
          )),
          fluidRow(
            column(
              12,
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
              )
            )
          ),
          fluidRow(
            column(
              4,
              div(class = "optionsSection",
                  uiOutput("selectIdsOutput", inline = TRUE),
                  actionButton("selectItems", "Select"),
                  checkboxInput("selectFocus", "Focus on selection", FALSE)
              )
            ),
            column(
              4,
              div(class = "optionsSection",
                  textInput("addText", tags$h4("Add item:"), "New item"),
                  dateInput("addDate", NULL, "2016-01-15"),
                  actionButton("addBtn", "Add")
              )
            ),
            column(
              4,
              div(class = "optionsSection",
                  uiOutput("removeIdsOutput", inline = TRUE),
                  actionButton("removeItem", "Remove")
              )
            )
          )
        ),
        column(4,
           div(
             id = "timelinedata",
             class = "optionsSection",
             tags$h4("Data:"),
             tableOutput("table"),
             hr(),
             div(tags$strong("Visible window:"),
                 textOutput("window", inline = TRUE)),
             div(tags$strong("Selected items:"),
                 textOutput("selected", inline = TRUE))
           )
        )
      ),
      div(class = "sourcecode",
          "The exact code for all the timelines in this app is",
          tags$a(href = "https://github.com/daattali/timevis/tree/master/inst/example",
                 "on GitHub")
      )
    )
  )
)
