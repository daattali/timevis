library(timevis)

source("sampleData.R")

# generate a random string of 16 characters
randomID <- function() {
  paste(sample(c(letters, LETTERS, 0:9), 16, replace = TRUE), collapse = "")
}

function(input, output, session) {
  output$timelineBasic <- renderTimevis({
    timevis(dataBasic)
  })

  output$timelineWC <- renderTimevis({
    timevis(dataWC)
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
    timevis(dataBasic, getSelected = TRUE, getData = TRUE, getIds = TRUE,
                getWindow = TRUE, options = config)
  })

  output$selected <- renderText(
    paste(input$timelineInteractive_selected, collapse = " ")
  )
  output$window <- renderText(
    paste(input$timelineInteractive_window[1], "to", input$timelineInteractive_window[2])
  )
  output$table <- renderTable(
    input$timelineInteractive_data
  )
  output$selectIdsOutput <- renderUI({
    selectInput("selectIds", "Select items:", input$timelineInteractive_ids,
                multiple = TRUE)
  })
  output$removeIdsOutput <- renderUI({
    selectInput("removeIds", "Remove item", input$timelineInteractive_ids)
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
}
