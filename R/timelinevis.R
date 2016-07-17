myitems <- data.frame(id=1:3,title=c(NA,"SFAD",NA),type=c("point","background","point"), content=c("item1","item 2", "item c"), group=c(1,2,1),className = c(NA, "aa", NA), start=c("2013-04-05", "2014-05-27", "2013-01-14"),end=c(NA, "2015-04-04", NA), stringsAsFactors = FALSE)
myitems2 <- data.frame(id=1:3,title=c(NA,"SFAD",NA), content=c("item1","item 2", "item c"), group=c(1,2,1),className = c(NA, "aa", NA), start=c("2016-07-11", "2016-07-13", "2016-07-14"),end=c(NA, "2016-07-15", NA), stringsAsFactors = FALSE)

#' Create a timeline visualization
#'
#' \code{timelinevis} lets you create rich and fully interactive timeline visualizations.
#' Timelines can be included in Shiny apps and R markdown documents, or viewed
#' from the R console and RStudio Viewer. Includes an extensive API to
#' manipulate a timeline after creation, and supports getting data out of the
#' visualization into R. Based on the \href{http://visjs.org/}{'vis.js'} Timeline
#' module and the \href{http://www.htmlwidgets.org/}{'htmlwidgets'} R package.
#' \cr\cr
#' View a \href{http://daattali.com/shiny/timelinevis-demo/}{demo Shiny app}
#' or see the full \href{https://github.com/daattali/timelinevis}{README} on
#' GitHub.
#'
#' @param data
#' @param showZoom
#' @param listen
#' @param options Any extra initialization options
#' any function argument must be wrapped in htmlwidgets::JS()
#' http://visjs.org/docs/timeline/#Configuration_Options
#' @param width Fixed width for timeline (in css units). Ignored when used in a
#' Shiny app -- use the \code{width} parameter in \code{timelinevisOutput}.
#' It is recommended to not use this parameter since the widget knows how to
#' adjust its width automatically.
#' @param height Fixed height for timeline (in css units). It is recommended to
#' not use this parameter since the widget knows how to adjust its height
#' automatically.
#' @param elementId Use an explicit element ID for the widget (rather than an
#' automatically generated one). Ignored when used in a Shiny app.
#'
#' @return A timeline visualization \code{htmlwidgets} object
#'
#' @examples
#' timelinevis()
#' timelinevis()
#'
#' @seealso \href{http://daattali.com/shiny/timelinevis-demo/}{Demo Shiny app}
#' @export
timelinevis <- function(data, showZoom = TRUE, listen, options,
  width = NULL, height = NULL, elementId = NULL) {

  # Validate the input data
  if (missing(data)) {
    data <- data.frame()
  }
  if (!is.data.frame(data)) {
    stop("timelinevis: 'data' must be a data.frame",
         call. = FALSE)
  }
  if (nrow(data) > 0 &&
      (!"start" %in% colnames(data) || anyNA(data[['start']]))) {
    stop("timelinevis: 'data' must contain a 'start' date for each item",
         call. = FALSE)
  }
  if (!is.logical(showZoom) || length(showZoom) != 1) {
    stop("timelinevis: 'showZoom' must be either 'TRUE' or 'FALSE'",
         call. = FALSE)
  }
  if (missing(listen)) {
    listen <- c()
  }
  if (missing(options) || is.null(options)) {
    options <- list()
  }
  if (!is.list(options)) {
    stop("timelinevis: 'options' must be a named list",
         call. = FALSE)
  }

  items <- dataframeToD3(data)

  # forward options using x
  x = list(
    items = items,
    showZoom = showZoom,
    listen = listen,
    options = options,
    height = height
  )

  # add dependencies so that the zoom buttons will work in non-Shiny mode
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
        title = "Zoom in",
        "+"
      ),
      htmltools::tags$button(
        type = "button",
        class = "btn btn-default btn-lg zoom-out",
        title = "Zoom out",
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
