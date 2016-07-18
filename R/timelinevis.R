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
#' @param data A data.frame containing the timeline items. 10 variables, NA
#' if an item doesn't have one TODO
#' @param showZoom If \code{TRUE} (default) then include "Zoom In"/"Zoom Out"
#' buttons on the widget.
#' @param listen TODO selected window data
#' See the examples section below to see example usage.
#' @param options A named list containing any extra configuration options to
#' customize the timeline. All available options can be found in the
#' \href{http://visjs.org/docs/timeline/#Configuration_Options}{official
#' Timeline documentation}. Note that any options that define a JavaScript
#' function must be wrapped in a call to \code{htmlwidgets::JS()}. See the
#' examples section below to see example usage.
#' @param width Fixed width for timeline (in css units). Ignored when used in a
#' Shiny app -- use the \code{width} parameter in
#' \code{\link[timelinevis]{timelinevisOutput}}.
#' It is not recommended to use this parameter because the widget knows how to
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
#' # For complete examples, see http://daattali.com/shiny/timelinevis-demo/
#'
#' # Most basic
#' timelinevis()
#'
#' # Minimal data
#' timelinevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-12"))
#' )
#'
#' # Hide the zoom buttons, allow items to be editable (add/remove/modify)
#' timelinevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-12")),
#'   showZoom = FALSE,
#'   options = list(editable = TRUE, height = "400px")
#' )
#'
#' # Items can be a single point or a range, and can contain HTML
#' timelinevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two<br><h3>HTML is supported</h3>"),
#'              start = c("2016-01-10", "2016-01-18"),
#'              end = c("2016-01-14", NA))
#' )
#'
#' # Alternative look for each item
#' timelinevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-18"),
#'              end = c("2016-01-14", NA),
#'              type = c("background", "point"))
#' )
#'
#' # Using a function in the configuration options
#' timelinevis(
#'   data.frame(id = 1,
#'              content = "double click anywhere<br>in the timeline<br>to add an item",
#'              start = "2016-01-01"),
#'   options = list(
#'     editable = TRUE,
#'     onAdd = htmlwidgets::JS('function(item, callback) {
#'       alert("An item was added");
#'       callback(item);
#'     }')
#'   )
#' )
#'
#' # Using the 'listen' parameter to get data from the widget into Shiny
#' TODO
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
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended. \code{height} will probably not
#'   have an effect; instead, use the \code{height} parameter in
#'   \code{\link[timelinevis]{timelinevis}}.
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
