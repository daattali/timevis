library(timevis)

source("sampleData.R")
source("utils.R")

function(input, output, session) {
  output$timelineBasic <- renderTimevis({
    timevis(dataBasic)
  })

  output$timelineWC <- renderTimevis({
    timevis(dataWC)
  })

  output$timelineGroups <- renderTimevis({
    groups <- timevisDataGroups
    if (input$nested) {
      groups$nestedGroups <- I(list(NA, list("sauna", "tub"), NA, NA))
    }
    timevis(data = timevisData, groups = groups, options = list(editable = TRUE))
  })

  output$timelineCustom <- renderTimevis({
    config <- list(
      editable = TRUE,
      align = "center",
      orientation = "top",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )
    timevis(dataBasic, zoomFactor = 1, options = config)
  })

  output$timelineInteractive <- renderTimevis({
    config <- list(
      editable = TRUE,
      multiselect = TRUE
    )
    timevis(dataBasic, options = config)
  })

  output$visible <- renderText(
    paste(input$timelineInteractive_visible, collapse = " ")
  )
  output$selected <- renderText(
    paste(input$timelineInteractive_selected, collapse = " ")
  )
  output$window <- renderText(
    paste(prettyDate(input$timelineInteractive_window[1]),
          "to",
          prettyDate(input$timelineInteractive_window[2]))
  )
  output$table <- renderTable({
    data <- input$timelineInteractive_data
    data$start <- prettyDate(data$start)
    if (!is.null(data$end)) {
      data$end <- prettyDate(data$end)
    }
    data
  })
  output$selectIdsOutput <- renderUI({
    selectInput("selectIds", tags$h4("Select items:"), input$timelineInteractive_ids,
                multiple = TRUE)
  })
  output$removeIdsOutput <- renderUI({
    selectInput("removeIds", tags$h4("Remove item"), input$timelineInteractive_ids)
  })

  observeEvent(input$fit, {
    fitWindow("timelineInteractive")
  })
  observeEvent(input$setWindowAnim, {
    setWindow("timelineInteractive", "2016-01-07", "2016-01-25")
  })
  observeEvent(input$setWindowNoAnim, {
    setWindow("timelineInteractive", "2016-01-07", "2016-01-25",
              options = list(animation = FALSE))
  })
  observeEvent(input$center, {
    centerTime("timelineInteractive", "2016-01-23")
  })
  observeEvent(input$focus2, {
    centerItem("timelineInteractive", 4)
  })
  observeEvent(input$focusSelection, {
    centerItem("timelineInteractive", input$timelineInteractive_selected)
  })
  observeEvent(input$selectItems, {
    setSelection("timelineInteractive", input$selectIds,
                 options = list(focus = input$selectFocus))
  })
  observeEvent(input$addBtn, {
    addItem("timelineInteractive",
            data = list(id = randomID(),
                        content = input$addText,
                        start = input$addDate))
  })
  observeEvent(input$removeItem, {
    removeItem("timelineInteractive", input$removeIds)
  })
  observeEvent(input$addTime, {
    addCustomTime("timelineInteractive", "2016-01-17", randomID())
  })
  observeEvent(input$zoomIn, {
    zoomIn("timelineInteractive", input$zoomBy, animation = input$animate)
  })
  observeEvent(input$zoomOut, {
    zoomOut("timelineInteractive", input$zoomBy, animation = input$animate)
  })

  eqs <- read.csv("earthquakes.csv")
  eqs$content <- paste("<strong>Magnitude:", eqs$magnitude, "</strong><br/><em>", eqs$start, "</em>")
  shared_df <- crosstalk::SharedData$new(eqs)

  output$timelineCrosstalk <- renderTimevis({
    timevis(shared_df, options = list(multiselect = TRUE))
  })
  output$map <- leaflet::renderLeaflet({
    leaflet::leaflet(shared_df) %>% leaflet::addTiles() %>% leaflet::addMarkers(lng = ~lng, lat = ~lat, label = ~start)
  })
}
