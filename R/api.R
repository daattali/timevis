callJS <- function() {
  # get the parameters from the function that have a value
  message <- Filter(function(x) !is.symbol(x), as.list(parent.frame(1)))
  session <- shiny::getDefaultReactiveDomain()

  # If a timevis widget was passed in, this is during a chain pipeline in the
  # initialization of the widget, so keep track of the desired function call
  # by adding it to a list of functions that should be performed when the widget
  # is ready
  if (methods::is(message$id, "timevis")) {
    widget <- message$id
    message$id <- NULL
    widget$x$api <- c(widget$x$api, list(message))
    return(widget)
  }
  # If an ID was passed, the widget already exists and we can simply call the
  # appropriate JS function
  else if (is.character(message$id)) {
    message$id <- session$ns(message$id)
    method <- paste0("timevis:", message$method)
    session$sendCustomMessage(method, message)
    return(message$id)
  } else {
    stop("The `id` argument must be either a timevis htmlwidget or an ID
         of a timevis htmlwidget.", call. = FALSE)
  }
}

#' Add a single item to a timeline
#'
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param data A named list containing the item data to add.
#' @examples
#'
#' timevis() %>%
#'   addItem(list(start = Sys.Date(), content = "Today"))
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Add item today")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
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
  callJS()
}

#' Add multiple items to a timeline
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param data A dataframe containing the items data to add.
#' @examples
#'
#' timevis() %>%
#'   addItems(data.frame(start = c(Sys.Date(), Sys.Date() - 1),
#'            content = c("Today", "Yesterday")))
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Add items today and yesterday")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
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
  callJS()
}

#' Remove an item from a timeline
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param itemId The id of the item to remove
#' @examples
#'
#' timevis(data.frame(id = 1:2, start = Sys.Date(), content = c("1", "2"))) %>%
#'   removeItem(2)
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Remove item 2")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis(data.frame(
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
  itemId <- as.character(itemId)
  callJS()
}

#' Add a new vertical bar at a time point that can be dragged by the user
#'
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param time The date/time to add
#' @param itemId The id of the custom time bar
#' @examples
#'
#' timevis() %>%
#'   addCustomTime(Sys.Date() - 1, "yesterday")
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Add time bar 24 hours ago")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
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
  callJS()
}

#' Adjust the time of a custom time bar
#'
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param time The new date/time
#' @param itemId The id of the custom time bar
#' @examples
#'
#' timevis() %>%
#'   addCustomTime(Sys.Date(), "yesterday") %>%
#'   setCustomTime(Sys.Date() - 1, "yesterday")
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Set time bar 24 hours ago")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis() %>% addCustomTime(Sys.Date(), "yesterday")
#'     )
#'     observeEvent(input$btn, {
#'       setCustomTime("timeline", Sys.Date() - 1, "yesterday")
#'     })
#'   }
#' )
#' }
#' @export
setCustomTime <- function(id, time, itemId) {
  method <- "setCustomTime"
  callJS()
}

#' Adjust the time of the current time bar
#'
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param time The new date/time
#' @examples
#'
#' timevis() %>%
#'   setCurrentTime(Sys.Date())
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Set current time to beginning of today")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
#'     )
#'     observeEvent(input$btn, {
#'       setCurrentTime("timeline", Sys.Date())
#'     })
#'   }
#' )
#' }
#' @export
setCurrentTime <- function(id, time) {
  method <- "setCurrentTime"
  callJS()
}

#' Remove a custom time previously added
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param itemId The id of the custom time bar
#' @examples
#'
#' timevis() %>%
#'   addCustomTime(Sys.Date() - 1, "yesterday") %>%
#'   addCustomTime(Sys.Date() + 1, "tomorrow") %>%
#'   removeCustomTime("yesterday")
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn0", "Add custom time"),
#'     actionButton("btn", "Remove custom time bar")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
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
  callJS()
}

#' Adjust the visible window such that it fits all items
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param options Named list of options controlling the animation. Most common
#' option is \code{"animation" = TRUE/FALSE}. For a full list of options, see
#' the "fit" method in the
#' \href{https://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Fit all items")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis(data.frame(
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
  callJS()
}

#' Move the window such that the given time is centered
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param time The date/time to center around
#' @param options Named list of options controlling the animation. Most common
#' option is \code{"animation" = TRUE/FALSE}. For a full list of options, see
#' the "moveTo" method in the
#' \href{https://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#'
#' timevis() %>%
#'   centerTime(Sys.Date() - 1)
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Center around 24 hours ago")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
#'     )
#'     observeEvent(input$btn, {
#'       centerTime("timeline", Sys.Date() - 1)
#'     })
#'   }
#' )
#' }
#' @export
centerTime <- function(id, time, options) {
  method <- "centerTime"
  callJS()
}

#' Move the window such that given item or items are centered
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param itemId A vector (or single value) of the item ids to center
#' @param options Named list of options controlling mainly the animation.
#' Most common option is \code{"animation" = TRUE/FALSE}. For a full list of
#' options, see the "focus" method in the
#' \href{https://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#'
#' timevis(data.frame(
#'           id = 1:3,
#'           start = c(Sys.Date() - 1, Sys.Date(), Sys.Date() + 1),
#'           content = c("Item 1", "Item 2", "Item 3"))
#' ) %>%
#'   centerItem(1)
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Center around item 1")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis(
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
  itemId <- as.character(itemId)
  callJS()
}

#' Set the items of a timeline
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param data A dataframe containing the item data to use.
#' @examples
#'
#' timevis(data.frame(start = Sys.Date(), content = "Today")) %>%
#'   setItems(data.frame(start = Sys.Date() - 1, content = "yesterday"))
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Change the data to yesterday")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis(data.frame(start = Sys.Date(), content = "Today"))
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
  callJS()
}

#' Set the groups of a timeline
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param data A dataframe containing the groups data to use.
#' @examples
#'
#' timevis(data = data.frame(
#'   start = c(Sys.Date(), Sys.Date(), Sys.Date() + 1, Sys.Date() + 2),
#'   content = c("one", "two", "three", "four"),
#'   group = c(1, 2, 1, 2)),
#'   groups = data.frame(id = 1:2, content = c("G1", "G2"))
#' ) %>%
#'   setGroups(data.frame(id = 1:2, content = c("Group 1", "Group 2")))
#'
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Change group names")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis(data = data.frame(
#'                start = c(Sys.Date(), Sys.Date(), Sys.Date() + 1, Sys.Date() + 2),
#'                          content = c("one", "two", "three", "four"),
#'                          group = c(1, 2, 1, 2)),
#'               groups = data.frame(id = 1:2, content = c("G1", "G2")))
#'
#'     )
#'     observeEvent(input$btn, {
#'       setGroups("timeline",
#'                data.frame(id = 1:2, content = c("Group 1", "Group 2")))
#'     })
#'   }
#' )
#' }
#' @export
setGroups <- function(id, data) {
  method <- "setGroups"
  data <- dataframeToD3(data)
  callJS()
}

#' Update the configuration options of a timeline
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param options A named list containing updated configuration options to use.
#' See the \code{options} parameter of the
#' \code{\link[timevis]{timevis}} function to see more details.
#' @examples
#'
#' timevis(
#'   data.frame(start = Sys.Date(), content = "Today"),
#'   options = list(showCurrentTime = FALSE, orientation = "top")
#' ) %>%
#'   setOptions(list(editable = TRUE, showCurrentTime = TRUE))
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Show current time and allow items to be editable")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis(
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
  callJS()
}

#' Select one or multiple items on a timeline
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param itemId A vector (or single value) of the item ids to select
#' @param options Named list of options controlling mainly the animation.
#' Most common options are \code{focus = TRUE/FALSE} and
#' \code{"animation" = TRUE/FALSE}. For a full list of options, see
#' the "setSelection" method in the
#' \href{https://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#'
#' timevis(data.frame(id = 1:3, start = Sys.Date(), content = 1:3)) %>%
#'   setSelection(2)
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Select item 2")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis(
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
  callJS()
}

#' Set the current visible window
#' @param id Timeline id or a \code{timevis} object (the output from \code{timevis()})
#' @param start The start date/time to show in the timeline
#' @param end The end date/time to show in the timeline
#' @param options Named list of options controlling mainly the animation.
#' Most common option is \code{animation = TRUE/FALSE}. For a full list of
#' options, see the "setWindow" method in the
#' \href{https://visjs.org/docs/timeline/#Methods}{official
#' Timeline documentation}
#' @examples
#'
#' timevis() %>%
#'   setWindow(Sys.Date() - 1, Sys.Date() + 1)
#'
#' if (interactive()) {
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     timevisOutput("timeline"),
#'     actionButton("btn", "Set window to show between yesterday to tomorrow")
#'   ),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
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
  callJS()
}
