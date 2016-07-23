callJS <- function(method) {
  # get the parameters from the function that have a value
  message <- Filter(function(x) !is.symbol(x), as.list(parent.frame(1)))
  session <- shiny::getDefaultReactiveDomain()

  # call the JS function
  method <- paste0("timelinevis:", method)
  session$sendCustomMessage(method, message)
}

#' Add a single item to a timeline
#' @param id Timeline id
#' @param data A named list containing the item data to add.
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Add item today")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis()
#'     )
#'     observeEvent(input$btn, {
#'       addItem("timeline", list(start = Sys.Date(), content = "Today"))
#'     })
#'   }
#' )
#' }
#' @export
addItem <- function(id, data) {
  method <- "addItem"
  callJS(method)
}

#' Add multiple items to a timeline
#' @param id Timeline id
#' @param data A dataframe containing the items data to add.
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Add items today and yesterday")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis()
#'     )
#'     observeEvent(input$btn, {
#'       addItems("timeline",
#'                data.frame(start = c(Sys.Date(), Sys.Date() - 1),
#'                           content = c("Today", "Yesterday")))
#'     })
#'   }
#' )
#' }
#' @export
addItems <- function(id, data) {
  method <- "addItems"
  data <- dataframeToD3(data)
  callJS(method)
}

#' Remove an item from a timeline
#' @param id Timeline id
#' @param itemId The id of the item to remove
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Remove item 2")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis(data.frame(
#'         id = 1:2, start = Sys.Date(), content = c("1", "2"))
#'       )
#'     )
#'     observeEvent(input$btn, {
#'       removeItem("timeline", 2)
#'     })
#'   }
#' )
#' }
#' @export
removeItem <- function(id, itemId) {
  method <- "removeItem"
  callJS(method)
}

#' Add new vertical bar at a time point that can be dragged by the user
#' @param id Timeline id
#' @param time The date/time to add
#' @param itemId The id of the custom time bar
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Add time bar 24 hours ago")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis()
#'     )
#'     observeEvent(input$btn, {
#'       addCustomTime("timeline", Sys.Date() - 1, "yesterday")
#'     })
#'   }
#' )
#' }
#' @export
addCustomTime <- function(id, time, itemId) {
  method <- "addCustomTime"
  callJS(method)
}

#' Remove a custom time previously added
#' @param id Timeline id
#' @param itemId The id of the custom time bar
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn0", "Add custom time"),
#'     actionButton("btn", "Remove custom time bar")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis()
#'     )
#'     observeEvent(input$btn0, {
#'       addCustomTime("timeline", Sys.Date() - 1, "yesterday")
#'     })
#'     observeEvent(input$btn, {
#'       removeCustomTime("timeline", "yesterday")
#'     })
#'   }
#' )
#' }
#' @export
removeCustomTime <- function(id, itemId) {
  method <- "removeCustomTime"
  callJS(method)
}

#' Adjust the visible window such that it fits all items
#' @param id Timeline id
#' @param options Named list of options controlling the animation. Most common
#' option is \code{"animation" = TRUE/FALSE}. For a full list of options, see
#' the "fit" method in the
#' \href{http://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Fit all items")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis(data.frame(
#'         id = 1:2, start = c(Sys.Date(), Sys.Date() - 1), content = c("1", "2")
#'       ))
#'     )
#'     observeEvent(input$btn, {
#'       fitWindow("timeline", list(animation = FALSE))
#'     })
#'   }
#' )
#' }
#' @export
fitWindow <- function(id, options) {
  method <- "fitWindow"
  callJS(method)
}

#' Move the window such that the given time is centered
#' @param id Timeline id
#' @param time The date/time to center around
#' @param options Named list of options controlling the animation. Most common
#' option is \code{"animation" = TRUE/FALSE}. For a full list of options, see
#' the "moveTo" method in the
#' \href{http://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Center around 24 hours ago")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis()
#'     )
#'     observeEvent(input$btn, {
#'       centerTime("timeline", Sys.Date())
#'     })
#'   }
#' )
#' }
#' @export
centerTime <- function(id, time, options) {
  method <- "centerTime"
  callJS(method)
}

#' Move the window such that given item or items are centered
#' @param id Timeline id
#' @param itemId A vector (or single value) of the item ids to center
#' @param options Named list of options controlling mainly the animation.
#' Most common option is \code{"animation" = TRUE/FALSE}. For a full list of
#' options, see the "focus" method in the
#' \href{http://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Center around item 1")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis(
#'         data.frame(id = 1:3,
#'           start = c(Sys.Date() - 1, Sys.Date(), Sys.Date() + 1),
#'           content = c("Item 1", "Item 2", "Item 3"))
#'       )
#'     )
#'     observeEvent(input$btn, {
#'       centerItem("timeline", 1)
#'     })
#'   }
#' )
#' }
#' @export
centerItem <- function(id, itemId, options) {
  method <- "centerItem"
  callJS(method)
}

#' Set the items of a timeline
#' @param id Timeline id
#' @param data A dataframe containing the item data to use.
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Change the data to yesterday")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis(data.frame(start = Sys.Date(), content = "Today"))
#'     )
#'     observeEvent(input$btn, {
#'       setItems("timeline",
#'                data.frame(start = Sys.Date() - 1, content = "yesterday"))
#'     })
#'   }
#' )
#' }
#' @export
setItems <- function(id, data) {
  method <- "setItems"
  data <- dataframeToD3(data)
  callJS(method)
}

#' Update the configuration options of a timeline
#' @param id Timeline id
#' @param options A named list containing updated configuration options to use.
#' See the \code{options} parameter of the
#' \code{\link[timelinevis]{timelinevis}} function to see more details.
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Show current time and allow items to be editable")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis(
#'         data.frame(start = Sys.Date(), content = "Today"),
#'         options = list(showCurrentTime = FALSE, orientation = "top")
#'       )
#'     )
#'     observeEvent(input$btn, {
#'       setOptions("timeline", list(editable = TRUE, showCurrentTime = TRUE))
#'     })
#'   }
#' )
#' }
#' @export
setOptions <- function(id, options) {
  method <- "setOptions"
  callJS(method)
}

#' Select one or multiple items on a timeline
#' @param id Timeline id
#' @param itemId A vector (or single value) of the item ids to select
#' @param options Named list of options controlling mainly the animation.
#' Most common options are \code{focus = TRUE/FALSE} and
#' \code{"animation" = TRUE/FALSE}. For a full list of options, see
#' the "setSelection" method in the
#' \href{http://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Select item 2")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis(
#'         data.frame(id = 1:3, start = Sys.Date(), content = 1:3)
#'       )
#'     )
#'     observeEvent(input$btn, {
#'       setSelection("timeline", 2)
#'     })
#'   }
#' )
#' }
#' @export
setSelection <- function(id, itemId, options) {
  method <- "setSelection"
  callJS(method)
}

#' Set the current visible window
#' @param id Timeline id
#' @param start The start date/time to show in the timeline
#' @param end The end date/time to show in the timeline
#' @param options Named list of options controlling mainly the animation.
#' Most common option is \code{animation = TRUE/FALSE}. For a full list of
#' options, see the "setWindow" method in the
#' \href{http://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timelinevisOutput("timeline"),
#'     actionButton("btn", "Set window to show between yesterday to tomorrow")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimelinevis(
#'       timelinevis()
#'     )
#'     observeEvent(input$btn, {
#'       setWindow("timeline", Sys.Date() - 1, Sys.Date() + 1)
#'     })
#'   }
#' )
#' }
#' @export
setWindow <- function(id, start, end, options) {
  method <- "setWindow"
  callJS(method)
}
