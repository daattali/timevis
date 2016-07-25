#' Create a timeline visualization
#'
#' \code{timevis} lets you create rich and fully interactive timeline visualizations.
#' Timelines can be included in Shiny apps and R markdown documents, or viewed
#' from the R console and RStudio Viewer. Includes an extensive API to
#' manipulate a timeline after creation, and supports getting data out of the
#' visualization into R. Based on the \href{http://visjs.org/}{'vis.js'} Timeline
#' module and the \href{http://www.htmlwidgets.org/}{'htmlwidgets'} R package.
#' \cr\cr
#' View a \href{http://daattali.com/shiny/timevis-demo/}{demo Shiny app}
#' or see the full \href{https://github.com/daattali/timevis}{README} on
#' GitHub.
#'
#' @param data A dataframe containing the timeline items. Each item on the
#' timeline is represented by a row in the dataframe. \code{start} and
#' \code{content} are required for each item, while the rest of the variables
#' are optional (if you include a variable that is only used for some rows,
#' you can use \code{NA} for the other rows). The supported variables are:
#' \itemize{
#'   \item{\strong{\code{start}}} - (required) The start date of the item, for
#'   example \code{"1988-11-22"} or \code{"1988-11-22 16:30:00"}.
#'   \item{\strong{\code{content}}} - (required) The contents of the item. This
#'   can be plain text or HTML code.
#'   \item{\strong{\code{end}}} - The end date of the item. The end date is
#'   optional. If end date is provided, the item is displayed as a range. If
#'   not, the item is displayed as a single point on the timeline.
#'   \item{\strong{\code{id}}} - An id for the item. Using an id is not required
#'   but highly recommended. An id is needed when removing or selecting items
#'   (using \code{\link[timevis]{removeItem}} or
#'   \code{\link[timevis]{setSelection}}) or when requesting to return
#'   selected items (using \code{getSelected}).
#'   \item{\strong{\code{type}}} - The type of the item. Can be 'box' (default),
#'   'point', 'range', or 'background'. Types 'box' and 'point' need only a
#'   start date, types 'range' and 'background' need both a start and end date.
#'   \item{\strong{\code{title}}} - Add a title for the item, displayed when
#'   hovering the mouse over the item. The title can only contain plain text.
#'   \item{\strong{\code{editable}}} - if \code{TRUE}, the item can be
#'   manipulated with the mouse. Overrides the global \code{editable}
#'   configuration option if it is set. An editable item can be removed or
#'   have its start/end dates modified by clicking on it.
#'   remove it or
#'   \item{\strong{\code{className}}} - A className can be used to give items an
#'   individual CSS style.
#'   \item{\strong{\code{style}}} - A CSS text string to apply custom styling
#'   for an individual item, for example \code{color: red;}.
#' }
#' @param showZoom If \code{TRUE} (default), then include "Zoom In"/"Zoom Out"
#' buttons on the widget.
#' @param zoomFactor How much to zoom when zooming out. A zoom factor of 0.5
#' means that when zooming out the timeline will show 50% more more content. For
#' example, if the timeline currently shows 20 days, then after zooming out with
#' a \code{zoomFactor} of 0.5, the timeline will show 30 days, and zooming out
#' again will show 45 days. Similarly, zooming out from 20 days with a
#' \code{zoomFactor} of 1 will results in showing 40 days.
#' @param getSelected If \code{TRUE}, then the selected items will
#' be accessible as a Shiny input. The input returns the ids of the selected
#' items and will be updated every time a new
#' item is selected by the user. The input name will be the timeline's id
#' appended by "_selected". For example, if the timeline \code{outputId}
#' is "mytimeline", then use \code{input$mytimeline_selected}.
#' @param getData If \code{TRUE}, then the items data will be accessible as a
#' Shiny input. The input returns a dataframe and will be updated every time
#' an item is modified, added, or removed. The input name will be the timeline's
#' id appended by "_data". For example, if the timeline \code{outputId} is
#' "mytimeline", then use \code{input$mytimeline_data}.
#' @param getIds If \code{TRUE}, then the IDs of the data items will be
#' accessible as a Shiny input. The input returns a vector of IDs and will be
#' updated every time an item is added or removed from the timeline. The input
#' name will be the timeline's id appended by "_ids". For example, if the
#' timeline \code{outputId} is "mytimeline", then use
#' \code{input$mytimeline_ids}.
#' @param getWindow If \code{TRUE}, then the current visible window will be
#' accessible as a Shiny input. The input returns a 2-element vector containing
#' the minimum and maximum dates currently visible in the timeline. The input
#' will be updated every time the window is updated (by zooming or moving).
#' The input name will be the timeline's id appended by "_window". For example,
#' if the timeline \code{outputId} is "mytimeline", then use
#' \code{input$mytimeline_window}.
#' @param options A named list containing any extra configuration options to
#' customize the timeline. All available options can be found in the
#' \href{http://visjs.org/docs/timeline/#Configuration_Options}{official
#' Timeline documentation}. Note that any options that define a JavaScript
#' function must be wrapped in a call to \code{htmlwidgets::JS()}. See the
#' examples section below to see example usage.
#' @param width Fixed width for timeline (in css units). Ignored when used in a
#' Shiny app -- use the \code{width} parameter in
#' \code{\link[timevis]{timevisOutput}}.
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
#' # For more examples, see http://daattali.com/shiny/timevis-demo/
#'
#' ### Most basic
#' timevis()
#'
#' ### Minimal data
#' timevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-12"))
#' )
#'
#' ### Hide the zoom buttons, allow items to be editable (add/remove/modify)
#' timevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-12")),
#'   showZoom = FALSE,
#'   options = list(editable = TRUE, height = "400px")
#' )
#'
#' ### Items can be a single point or a range, and can contain HTML
#' timevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two<br><h3>HTML is supported</h3>"),
#'              start = c("2016-01-10", "2016-01-18"),
#'              end = c("2016-01-14", NA))
#' )
#'
#' ### Alternative look for each item
#' timevis(
#'   data.frame(id = 1:2,
#'              content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-18"),
#'              end = c("2016-01-14", NA),
#'              type = c("background", "point"))
#' )
#'
#' ### Using a function in the configuration options
#' timevis(
#'   data.frame(id = 1,
#'              content = "double click anywhere<br>in the timeline<br>to add an item",
#'              start = "2016-01-01"),
#'   options = list(
#'     editable = TRUE,
#'     onAdd = htmlwidgets::JS('function(item, callback) {
#'       item.content = "Hello!<br/>" + item.content;
#'       callback(item);
#'     }')
#'   )
#' )
#'
#' ### Having read-only and editable items together
#' timevis(
#'   data.frame(id = 1:2,
#'              content = c("editable", "read-only"),
#'              start = c("2016-01-01", "2016-01-18"),
#'              editable = c(TRUE, FALSE),
#'              style = c(NA, "background: red; color: white;"))
#' )
#'
#'
#' ### Getting data out of the timeline into Shiny
#' if (interactive()) {
#' library(shiny)
#'
#' data <- data.frame(
#'   id = 1:3,
#'   start = c("2015-04-04", "2015-04-05 11:00:00", "2015-04-06 15:00:00"),
#'   end = c("2015-04-08", NA, NA),
#'   content = c("<h2>Vacation!!!</h2>", "Acupuncture", "Massage"),
#'   style = c("color: red;", NA, NA)
#' )
#'
#' ui <- fluidPage(
#'   timevisOutput("appts"),
#'   div("Selected items:", textOutput("selected", inline = TRUE)),
#'   div("Visible window:", textOutput("window", inline = TRUE)),
#'   tableOutput("table")
#' )
#'
#' server <- function(input, output) {
#'   output$appts <- renderTimevis(
#'     timevis(
#'       data, getSelected = TRUE, getData = TRUE, getWindow = TRUE,
#'       options = list(editable = TRUE, multiselect = TRUE, align = "center")
#'     )
#'   )
#'
#'   output$selected <- renderText(
#'     paste(input$appts_selected, collapse = " ")
#'   )
#'
#'   output$window <- renderText(
#'     paste(input$appts_window[1], "to", input$appts_window[2])
#'   )
#'
#'   output$table <- renderTable(
#'     input$appts_data
#'   )
#' }
#' shinyApp(ui, server)
#' }
#'
#' @seealso \href{http://daattali.com/shiny/timevis-demo/}{Demo Shiny app}
#' @export
timevis <- function(data, showZoom = TRUE, zoomFactor = 0.5,
                        getSelected = FALSE, getData = FALSE, getIds = FALSE,
                        getWindow = FALSE, options, width = NULL, height = NULL,
                        elementId = NULL) {

  # Validate the input data
  if (missing(data)) {
    data <- data.frame()
  }
  if (!is.data.frame(data)) {
    stop("timevis: 'data' must be a data.frame",
         call. = FALSE)
  }
  if (nrow(data) > 0 &&
      (!"start" %in% colnames(data) || anyNA(data[['start']]))) {
    stop("timevis: 'data' must contain a 'start' date for each item",
         call. = FALSE)
  }
  if (!is.bool(showZoom)) {
    stop("timevis: 'showZoom' must be either 'TRUE' or 'FALSE'",
         call. = FALSE)
  }
  if (!is.numeric(zoomFactor) || length(zoomFactor) > 1 || zoomFactor <= 0) {
    stop("timevis: 'zoomFactor' must be a positive number",
         call. = FALSE)
  }
  if (!is.bool(getSelected)) {
    stop("timevis: 'getSelected' must be either 'TRUE' or 'FALSE'",
         call. = FALSE)
  }
  if (!is.bool(getData)) {
    stop("timevis: 'getData' must be either 'TRUE' or 'FALSE'",
         call. = FALSE)
  }
  if (!is.bool(getIds)) {
    stop("timevis: 'getIds' must be either 'TRUE' or 'FALSE'",
         call. = FALSE)
  }
  if (!is.bool(getWindow)) {
    stop("timevis: 'getWindow' must be either 'TRUE' or 'FALSE'",
         call. = FALSE)
  }
  if (missing(options) || is.null(options)) {
    options <- list()
  }
  if (!is.list(options)) {
    stop("timevis: 'options' must be a named list",
         call. = FALSE)
  }

  items <- dataframeToD3(data)

  # forward options using x
  x = list(
    items = items,
    showZoom = showZoom,
    zoomFactor = zoomFactor,
    getSelected = getSelected,
    getData = getData,
    getIds = getIds,
    getWindow = getWindow,
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
    name = 'timevis',
    x,
    width = width,
    height = height,
    package = 'timevis',
    elementId = elementId,
    dependencies = deps
  )
}

#' Shiny bindings for timevis
#'
#' Output and render functions for using timevis within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended. \code{height} will probably not
#'   have an effect; instead, use the \code{height} parameter in
#'   \code{\link[timevis]{timevis}}.
#' @param expr An expression that generates a timevis
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name timevis-shiny
#' @seealso \code{\link[timevis]{timevis}}.
#'
#' @examples
#' if (interactive()) {
#' library(shiny)
#'
#' ### Most basic example
#' shinyApp(
#'   ui = fluidPage(timevisOutput("timeline")),
#'   server = function(input, output) {
#'     output$timeline <- renderTimevis(
#'       timevis()
#'     )
#'   }
#' )
#'
#'
#' ### More advanced example
#' data <- data.frame(
#'   id = 1:3,
#'   start = c("2015-04-04", "2015-04-05 11:00:00", "2015-04-06 15:00:00"),
#'   end = c("2015-04-08", NA, NA),
#'   content = c("<h2>Vacation!!!</h2>", "Acupuncture", "Massage"),
#'   style = c("color: red;", NA, NA)
#' )
#'
#' ui <- fluidPage(
#'   timevisOutput("appts"),
#'   div("Selected items:", textOutput("selected", inline = TRUE)),
#'   div("Visible window:", textOutput("window", inline = TRUE)),
#'   tableOutput("table")
#' )
#'
#' server <- function(input, output) {
#'   output$appts <- renderTimevis(
#'     timevis(
#'       data, getSelected = TRUE, getData = TRUE, getWindow = TRUE,
#'       options = list(editable = TRUE, multiselect = TRUE, align = "center")
#'     )
#'   )
#'
#'   output$selected <- renderText(
#'     paste(input$appts_selected, collapse = " ")
#'   )
#'
#'   output$window <- renderText(
#'     paste(input$appts_window[1], "to", input$appts_window[2])
#'   )
#'
#'   output$table <- renderTable(
#'     input$appts_data
#'   )
#' }
#' shinyApp(ui, server)
#' }
#'
#' @export
timevisOutput <- function(outputId, width = '100%', height = 'auto') {
  htmlwidgets::shinyWidgetOutput(outputId, 'timevis', width, height, package = 'timevis')
}

#' @rdname timevis-shiny
#' @export
renderTimevis <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, timevisOutput, env, quoted = TRUE)
}

# Add custom HTML to wrap the widget to allow for a zoom in/out menu
timevis_html <- function(id, style, class, ...){
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
