library(timevis)

source("ui-helpers.R")

fluidPage(
  shinydisconnect::disconnectMessage2(),
  title = "timevis - An R package for creating timeline visualizations",
  tags$head(
    tags$link(href = "style.css", rel = "stylesheet"),

    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="https://daattali.com/shiny/img/favicon.ico"),

    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = share$title),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),

    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary_large_image"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),
  div(id = "header",
    div(id = "title",
      "timevis"
    ),
    div(id = "subtitle",
        "An R package for creating timeline visualizations"),
    div(id = "subsubtitle",
        "By",
        tags$a(href = "https://deanattali.com/", "Dean Attali"),
        HTML("&bull;"),
        "Available",
        tags$a(href = "https://github.com/daattali/timevis", "on GitHub"),
        HTML("&bull;"),
        tags$a(href = "https://github.com/sponsors/daattali", "Support my work"), "❤"
    ),
    br(),
    tags$a(
      "View Documentation", icon("external-link"),
      href = "https://github.com/daattali/timevis#readme",
      class = "btn btn-lg btn-default",
      style = "text-shadow: none;"
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
      )
    ),

    tabPanel(
      div(icon("cog"), "Custom style"),
      timevisOutput("timelineCustom")
    ),

    tabPanel(
      div(icon("trophy"), "World Cup 2014"),
      timevisOutput("timelineWC")
    ),

    tabPanel(
      div(icon("users"), "Groups"),
      checkboxInput("nested", "Use nested groups (Sauna and Hot Tub are collapsible under Pool)", FALSE, width = "auto"),
      timevisOutput("timelineGroups")
    ),

    tabPanel(
      div(icon("sliders-h"), "Fully interactive"),
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
              3,
              div(class = "optionsSection",
                  uiOutput("selectIdsOutput", inline = TRUE),
                  actionButton("selectItems", "Select"),
                  checkboxInput("selectFocus", "Focus on selection", FALSE)
              )
            ),
            column(
              3,
              div(class = "optionsSection",
                  textInput("addText", tags$h4("Add item:"), "New item"),
                  dateInput("addDate", NULL, "2016-01-15"),
                  actionButton("addBtn", "Add")
              )
            ),
            column(
              3,
              div(class = "optionsSection",
                  uiOutput("removeIdsOutput", inline = TRUE),
                  actionButton("removeItem", "Remove")
              )
            ),
            column(
              3,
              div(
                class = "optionsSection",
                sliderInput("zoomBy", tags$h4("Zoom:"), min = 0, max = 1, value = 0.5, step = 0.1),
                checkboxInput("animate", "Animate?", TRUE),
                actionButton("zoomIn", "Zoom In"),
                actionButton("zoomOut", "Zoom Out")
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
                 textOutput("selected", inline = TRUE)),
             div(tags$strong("Visible items:"),
                 textOutput("visible", inline = TRUE)),
           )
        )
      )
    ),
    tabPanel(
      div(icon("link"), "Crosstalk"),
      div(
        id = "crosstalk-tab",
        tags$p(strong(
          "{timevis} is fully compatible with",
          tags$a("Crosstalk", href = "https://github.com/rstudio/crosstalk"),
        )),
        tags$p(
          "The data in the timeline and the plot below are linked - select any events in the timeline to see",
          "them highlighted on the plot, and vice versa."
        ),
        HTML("Use <i>ctrl</i> or <i>shift</i> to select multiple events"),
        fluidRow(
          column(
            6,
            timevisOutput("timelineCrosstalk")
          ),
          column(
            6,
            d3scatter::d3scatterOutput("plot")
          )
        ),
        br()
      )
    )
  ),
  div(class = "sourcecode",
      "The exact code for all the timelines in this app is",
      tags$a(href = "https://github.com/daattali/timevis/tree/master/inst/example",
             "on GitHub")
  )
)
