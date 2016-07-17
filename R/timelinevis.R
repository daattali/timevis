myitems <- data.frame(id=1:3,title=c(NA,"SFAD",NA),type=c("point","background","point"), content=c("item1","item 2", "item c"), group=c(1,2,1),className = c(NA, "aa", NA), start=c("2013-04-05", "2014-05-27", "2013-01-14"),end=c(NA, "2015-04-04", NA), stringsAsFactors = FALSE)
myitems2 <- data.frame(id=1:3,title=c(NA,"SFAD",NA), content=c("item1","item 2", "item c"), group=c(1,2,1),className = c(NA, "aa", NA), start=c("2016-07-11", "2016-07-13", "2016-07-14"),end=c(NA, "2016-07-15", NA), stringsAsFactors = FALSE)

#' <Add Title>
#'
#' <Add Description>
#'
#' ... any function argument must be wrapped in htmlwidgets::JS()
#'
#' @import htmlwidgets
#'
#' @export
timelinevis <- function(
  data, showZoom = TRUE,
  listen = NULL,
  width = NULL, height = NULL, elementId = NULL,
  ...) {

  if (missing(data)) {
    data <- data.frame()
  }

  items <- dataframeToD3(data)

  # forward options using x
  x = list(
    items = items,
    showZoom = showZoom,
    listen = listen,
    height = height
  )

  x <- c(x, list(...))

  deps <- list(
    rmarkdown::html_dependency_jquery(),
    rmarkdown::html_dependency_bootstrap("default")
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'timelinevis',
    x,
    width = width,
    height = height,
    package = 'timelinevis',
    elementId = elementId,
    dependencies = deps
  )
}

#' Shiny bindings for timelinevis
#'
#' Output and render functions for using timelinevis within Shiny
#' applications and interactive Rmd documents.
#'
#' TODO height ignored, pass it to timeline()
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a timelinevis
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name timelinevis-shiny
#'
#' @export
timelinevisOutput <- function(outputId, width = '100%', height = 'auto') {
  htmlwidgets::shinyWidgetOutput(outputId, 'timelinevis', width, height, package = 'timelinevis')
}

#' @rdname timelinevis-shiny
#' @export
renderTimelinevis <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, timelinevisOutput, env, quoted = TRUE)
}

# Add custom HTML to wrap the widget to allow for a zoom in/out menu
timelinevis_html <- function(id, style, class, ...){
  htmltools::tags$div(
    id = id, class = class, style = style,
    htmltools::tags$div(
      class = "btn-group zoom-menu",
      htmltools::tags$button(
        type = "button",
        class = "btn btn-default btn-lg zoom-in",
        "+"
      ),
      htmltools::tags$button(
        type = "button",
        class = "btn btn-default btn-lg zoom-out",
        "-"
      )
    )
  )
}

dataframeToD3 <- function(df) {
  if (missing(df)) {
    return(list())
  }
  apply(df, 1, function(row) as.list(row[!is.na(row)]))
}

addItem <- function(id, data) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:addItem", message)
}

addItems <- function(id, data) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  message[['data']] <- dataframeToD3(message[['data']])
  session$sendCustomMessage("timelinevis:addItems", message)
}

removeItem <- function(id, itemId) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:removeItem", message)
}

addCustomTime <- function(id, time, itemId) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:addCustomTime", message)
}

removeCustomTime <- function(id, itemId) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:removeCustomTime", message)
}

fitWindow <- function(id, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:fitWindow", message)
}

centerTime <- function(id, time, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:centerTime", message)
}

setItems <- function(id, data) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  message[['data']] <- dataframeToD3(message[['data']])
  session$sendCustomMessage("timelinevis:setItems", message)
}

setOptions <- function(id, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:setOptions", message)
}

setSelection <- function(id, itemId, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:setSelection", message)
}

setWindow <- function(id, start, end, options) {
  message <- Filter(function(x) !is.symbol(x), as.list(environment()))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("timelinevis:setWindow", message)
}

.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("timelinevisDF", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  })
}
