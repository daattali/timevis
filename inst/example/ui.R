library(timevis)

source("ui-helpers.R")

fluidPage(
  title = "timevis - An R package for creating timeline visualizations",
  tags$head(
    tags$link(href = "style.css", rel = "stylesheet"),

    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="http://daattali.com/shiny/img/favicon.ico"),

    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = share$title),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),

    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),
  tags$a(
    href="https://github.com/daattali/timevis",
    tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
             src="github-orange-right.png",
             alt="Fork me on GitHub")
  ),
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
        "Available",
        tags$a(href = "https://github.com/daattali/timevis", "on GitHub"),
        HTML("&bull;"),
        tags$a(href = "http://daattali.com/shiny/", "More apps"), "by Dean"
    )
  ),
  tabsetPanel(
    id = "mainnav",
    tabPanel(
      div(icon("calendar"), "Basic timeline"),
      timevisOutput("timelineBasic"),
      div(
        id = "samplecode",
        fluidRow(
          column(
            6,
            div(class = "codeformat",
              "In R console or R markdown documents"),
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
      div(icon("cog"), "Custom style"),
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
      div(icon("users"), "Groups"),
      timevisOutput("timelineGroups"),
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
