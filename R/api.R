callJS <- function(method) {
  # get the parameters from the function that have a value
  message <- Filter(function(x) !is.symbol(x), as.list(parent.frame(1)))
  session <- shiny::getDefaultReactiveDomain()

  # call the JS function
  method <- paste0("timelinevis:", method)
  session$sendCustomMessage(method, message)
}

#' @export
addItem <- function(id, data) {
  method <- "addItem"
  callJS(method)
}

#' @export
addItems <- function(id, data) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:addItems", message)
}

#' @export
removeItem <- function(id, itemId) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:removeItem", message)
}

#' @export
addCustomTime <- function(id, time, itemId) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:addCustomTime", message)
}

#' @export
removeCustomTime <- function(id, itemId) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:removeCustomTime", message)
}

#' @export
fitWindow <- function(id, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:fitWindow", message)
}

#' @export
centerTime <- function(id, time, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:centerTime", message)
}

#' @export
setItems <- function(id, data) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:setItems", message)
}

#' @export
setOptions <- function(id, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:setOptions", message)
}

#' @export
setSelection <- function(id, itemId, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:setSelection", message)
}

#' @export
setWindow <- function(id, start, end, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:setWindow", message)
}
