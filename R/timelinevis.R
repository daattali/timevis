myitems <- data.frame(id=1:3,title=c(NA,"SFAD",NA),type=c("point","background","point"), content=c("item1","item 2", "item c"), group=c(1,2,1),className = c(NA, "aa", NA), start=c("2013-04-05", "2014-05-27", "2013-01-14"),end=c(NA, "2015-04-04", NA), stringsAsFactors = FALSE)
myitems2 <- data.frame(id=1:3,title=c(NA,"SFAD",NA), content=c("item1","item 2", "item c"), group=c(1,2,1),className = c(NA, "aa", NA), start=c("2016-07-11", "2016-07-13", "2016-07-14"),end=c(NA, "2016-07-15", NA), stringsAsFactors = FALSE)

#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
timelinevis <- function(items, width = NULL, height = NULL, elementId = NULL) {

  items <- dataframeToD3(items)

  # forward options using x
  x = list(
    items = items
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'timelinevis',
    x,
    width = width,
    height = height,
    package = 'timelinevis',
    elementId = elementId
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

dataframeToD3 <- function(df) {
  apply(df, 1, function(row) as.list(row[!is.na(row)]))
}
