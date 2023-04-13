#' Create a timeline visualization
#'
#' \code{timevis} lets you create rich and fully interactive timeline visualizations.
#' Timelines can be included in Shiny apps or R markdown documents.
#' \code{timevis} Includes an extensive
#' API to manipulate a timeline after creation, and supports getting data out of
#' the visualization into R. Based on the \href{https://visjs.github.io/vis-timeline/docs/timeline/}{'visjs'}
#' Timeline JavaScript library.\cr\cr
#' View a \href{https://daattali.com/shiny/timevis-demo/}{demo Shiny app}
#' or see the full \href{https://github.com/daattali/timevis#readme}{README} on
#' GitHub.\cr\cr
#' **Important note: This package provides a way to use the
#' \href{https://visjs.github.io/vis-timeline/docs/timeline/}{visjs Timeline JavaScript library} within R.
#' The visjs Timeline library has too many features that cannot all be documented
#' here. To see the full details on what the timeline can support, please read the
#' official documentation of visjs Timeline.**
#'
#' @param data A dataframe (or \link[crosstalk]{SharedData} object for \{crosstalk\} support) containing the timeline items.
#' Each item on the timeline is represented by a row in the dataframe. \code{start} and
#' \code{content} are the only two required columns.
#' See the \strong{Data format} section below for more
#' details. For a full list of all supported columns, see the Data Format section in the
#' \href{https://visjs.github.io/vis-timeline/docs/timeline/#Data_Format}{official
#' visjs Timeline documentation}.
#' @param groups A dataframe containing the groups data (optional). See the
#' \strong{Groups} section below for more details.
#' @param showZoom If \code{TRUE} (default), then include "Zoom In"/"Zoom Out"
#' buttons on the widget.
#' @param zoomFactor How much to zoom when zooming out. A zoom factor of 0.5
#' means that when zooming out the timeline will show 50% more content. For
#' example, if the timeline currently shows 20 days, then after zooming out with
#' a \code{zoomFactor} of 0.5, the timeline will show 30 days, and zooming out
#' again will show 45 days. Similarly, zooming out from 20 days with a
#' \code{zoomFactor} of 1 will results in showing 40 days.
#' @param fit If \code{TRUE}, then fit all the data on the timeline when the
#' timeline initializes. Otherwise, the timeline will be set to show the
#' current date.
#' @param options A named list containing any extra configuration options to
#' customize the timeline. All available options can be found in the
#' \href{https://visjs.github.io/vis-timeline/docs/timeline/#Configuration_Options}{official
#' Timeline documentation}. Note that any options that define a JavaScript
#' function must be wrapped in a call to \code{htmlwidgets::JS()}. See the
#' examples section below to see example usage. If using \{crosstalk\}, it's recommended
#' to use `list(multiselect = TRUE)`.
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
#' @param loadDependencies Whether to load JQuery and bootstrap
#' dependencies (you should only set to \code{FALSE} if you manually include
#' them)
#' @param timezone By default, the timevis widget displays times in the local
#' time of the browser rendering it. You can set timevis to display times in
#' another time zone by providing a number between -15 to 15 to specify the
#' number of hours offset from UTC. For example, use `0` to display in UTC,
#' and use `-4` to display in a timezone that is 4 hours behind UTC.
#' @return A timeline visualization \code{htmlwidgets} object
#' @section Data format:
#' The \code{data} parameter supplies the input dataframe that describes the
#' items in the timeline. The following is a subset of the variables supported
#' in the items dataframe. \strong{The full list of supported variables can be found in
#' the \href{https://visjs.github.io/vis-timeline/docs/timeline/#Data_Format}{official
#' visjs documentation}}.
#' \itemize{
#'   \item{\strong{\code{start}}} - (required) The start date of the item, for
#'   example \code{"1988-11-22"} or \code{"1988-11-22 16:30:00"}. To specify BCE
#'   dates you must use 6 digits (for example `"-000600"` corresponds to year 600BCE).
#'   To specify dates between year 0 and year 99 CE, you must use 4 digits.
#'   \item{\strong{\code{content}}} - (required) The contents of the item. This
#'   can be plain text or HTML code.
#'   \item{\strong{\code{end}}} - The end date of the item. The end date is
#'   optional. If end date is provided, the item is displayed as a range. If
#'   not, the item is displayed as a single point on the timeline.
#'   \item{\strong{\code{id}}} - A unique ID for the item. If not provided,
#'   then the row names will be used as IDs. The ID is used when removing or
#'   selecting items (using \code{\link[timevis]{removeItem}} or
#'   \code{\link[timevis]{setSelection}}).
#'   \item{\strong{\code{type}}} - The type of the item. Can be 'box' (default),
#'   'point', 'range', or 'background'. Types 'box' and 'point' need only a
#'   start date, types 'range' and 'background' need both a start and end date.
#'   \item{\strong{\code{title}}} - Add a title for the item, displayed when
#'   hovering the mouse over the item. The title can only contain plain text.
#'   \item{\strong{\code{editable}}} - If \code{TRUE}, the item can be
#'   manipulated with the mouse. Overrides the global \code{editable}
#'   configuration option if it is set. An editable item can be removed or
#'   have its start/end dates modified by clicking on it.
#'   \item{\strong{\code{group}}} - The ID of a group. When a \code{group} is
#'   provided, all items with the same group are placed on one line. A vertical
#'   axis is displayed showing the group names. See more details in the
#'   \strong{Groups} section below.
#'   \item{\strong{\code{className}}} - A className can be used to give items an
#'   individual CSS style.
#'   \item{\strong{\code{style}}} - A CSS text string to apply custom styling
#'   for an individual item, for example \code{color: red;}.
#' }
#' \code{start} and \code{content} are the only required variables for each
#' item, while the rest of the variables are optional. If you include a variable
#' that is only used for some rows, you can use \code{NA} for the rows where
#' it's not used. The items data of a timeline can either be set by supplying
#' the \code{data} argument to \code{timevis()}, or by calling the
#' \code{\link[timevis]{setItems}} function.
#' @section Groups:
#' The \code{groups} parameter must be provided if the data items have groups
#' (ie. if any of the items have a \code{group} variable). When using groups, all
#' items with the same group are placed on one line. A vertical axis is
#' displayed showing the group names. Grouping items can be useful for a wide range
#' of applications, for example when showing availability of multiple people,
#' rooms, or other resources next to each other. You can also think of groups as
#' "adding a Y axis".\cr\cr
#' The following is a subset of the variables supported in
#' the groups dataframe. \strong{The full list of supported variables can be found in
#' the \href{https://visjs.github.io/vis-timeline/docs/timeline/#groups}{official
#' visjs documentation}}.
#' \itemize{
#'   \item{\strong{\code{id}}} - (required) An ID for the group. The group will
#'   display all items having a \code{group} variable which matches this ID.
#'   \item{\strong{\code{content}}} - (required) The contents of the group. This
#'   can be plain text or HTML code.
#'   \item{\strong{\code{title}}} - Add a title for the group, displayed when
#'   hovering the mouse over the group's label. The title can only contain
#'   plain text.
#'   \item{\strong{\code{nestedGroups}}} - List of group ids nested in the group.
#'   The syntax for defining a dataframe with a list inside a column can be tricky,
#'   see the examples below for sample usage.
#'   \item{\strong{\code{className}}} - A className can be used to give groups
#'   an individual CSS style.
#'   \item{\strong{\code{style}}} - A CSS text string to apply custom styling
#'   for an individual group label, for example \code{color: red;}.
#' }
#' \code{id} and \code{content} are the only required variables for each group,
#' while the rest of the variables are optional. If you include a variable that
#' is only used for some rows, you can use \code{NA} for the rows where it's
#' not used. The groups data of a timeline can either be set by supplying the
#' \code{groups} argument to \code{timevis()}, or by calling the
#' \code{\link[timevis]{setGroups}} function.
#' @section Getting data out of a timeline in Shiny:
#' When a timeline widget is created in a Shiny app, there are four pieces of
#' information that are always accessible as Shiny inputs. These inputs have
#' special names based on the timeline's ID. Suppose that a timeline is created
#' with an \code{outputId} of \strong{"mytime"}, then the following four input
#' variables will be available:
#' \itemize{
#'   \item{\strong{\code{input$mytime_data}}} - will return a data.frame containing
#'   the data of the items in the timeline. The input is updated every time
#'   an item is modified, added, or removed.
#'   \item{\strong{\code{input$mytime_ids}}} - will return the IDs (a vector) of
#'   all the items in the timeline. The input is updated every time an item
#'   is added or removed from the timeline.
#'   \item{\strong{\code{input$mytime_selected}}} - will return the IDs (a vector)
#'   of the selected items in the timeline. The input is updated every time an
#'   item is selected or unselected by the user. Note that this will not get updated if
#'   an item is selected programmatically using
#'   \code{\link[timevis]{setSelection}}.
#'   \item{\strong{\code{input$mytime_window}}} - will return a 2-element vector
#'   containing the minimum and maximum dates currently visible in the timeline.
#'   The input is updated every time the viewable window of dates is updated
#'   (by zooming or moving the window).
#'   \item{\strong{\code{input$mytime_visible}}} - will return a list of IDs of items currently
#'   visible in the timeline.
#' }
#' All four inputs will return a value upon initialization of the timeline and
#' every time the corresponding value is updated.
#' @section Extending timevis:
#' If you need to perform any actions on the timeline object that are not
#' supported by this package's API, you may be able to do so by manipulating the
#' timeline's JavaScript object directly. The timeline object is available via
#' \code{document.getElementById("id").widget.timeline} (replace \code{id} with
#' the timeline's ID).\cr\cr
#' This timeline object is the direct widget that \code{vis.js} creates, and you
#' can see the \href{https://visjs.github.io/vis-timeline/docs/timeline/}{visjs documentation} to
#' see what actions you can perform on that object.
#' @section Customizing the timevis look and style using CSS:
#' To change the styling of individual items or group labels, use the
#' \code{className} and \code{style} columns in the \code{data} or \code{groups}
#' dataframes.\cr\cr
#' When running a Shiny app, you can use CSS files to apply custom styling to
#' other components of the timevis widget. When using timevis outside of a Shiny
#' app, you can use CSS in the following way:\cr
#' \preformatted{
#' tv <- timevis(
#'   data.frame(
#'     content = "Today",
#'     start = Sys.Date()
#'   )
#' )
#'
#' style <- "
#' .vis-timeline {
#'   border-color: #269026;
#'   background-color: lightgreen;
#'   font-size: 15px;
#'   color: green;
#' }
#'
#' .vis-item {
#'   border: 2px solid #5ace5a;
#'   font-size: 12pt;
#'   background: #d9ffd9;
#'   font-family: cursive;
#'   padding: 5px;
#' }
#' "
#'
#' tv <- tagList(tags$style(style), tv)
#' htmltools::html_print(tv)
#' }
#' @examples
#' \dontrun{
#' # For more examples, see https://daattali.com/shiny/timevis-demo/
#'
#' #----------------------- Most basic -----------------
#' timevis()
#'
#' #----------------------- Minimal data -----------------
#' timevis(
#'   data.frame(content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-12"))
#' )
#'
#' #----------------------- Hide the zoom buttons, allow items to be editable -----------------
#' timevis(
#'   data.frame(content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-12")),
#'   showZoom = FALSE,
#'   options = list(editable = TRUE, height = "200px")
#' )
#'
#' #----------------------- You can use %>% pipes to create timevis pipelines -----------------
#' timevis() %>%
#'   setItems(data.frame(
#'     content = c("one", "two"),
#'     start = c("2016-01-10", "2016-01-12")
#'   )) %>%
#'   setOptions(list(editable = TRUE)) %>%
#'   addItem(list(id = 3, content = "three", start = "2016-01-11")) %>%
#'   setSelection("3") %>%
#'   fitWindow(list(animation = FALSE))
#'
#' #------- Items can be a single point or a range, and can contain HTML -------
#' timevis(
#'   data.frame(content = c("one", "two<br><h3>HTML is supported</h3>"),
#'              start = c("2016-01-10", "2016-01-18"),
#'              end = c("2016-01-14", NA),
#'              style = c(NA, "color: red;")
#'   )
#' )
#'
#' #----------------------- Alternative look for each item -----------------
#' timevis(
#'   data.frame(content = c("one", "two"),
#'              start = c("2016-01-10", "2016-01-14"),
#'              end = c(NA, "2016-01-18"),
#'              type = c("point", "background"))
#' )
#'
#' #----------------------- Using a function in the configuration options -----------------
#' timevis(
#'   data.frame(content = "double click anywhere<br>in the timeline<br>to add an item",
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
#'
#' #----------------------- Using a custom format for hours ------------------
#' timevis(
#'   data.frame(
#'     content = c("one", "two"),
#'     start = c("2020-01-10", "2020-01-10 04:00:00")
#'   ),
#'   options = list(
#'     format = htmlwidgets::JS("{ minorLabels: { minute: 'h:mma', hour: 'ha' }}")
#'   )
#' )
#'
#' #----------------------- Allowing editable items to "snap" to round hours only -------------
#' timevis(
#'   data.frame(
#'     content = c("one", "two"),
#'     start = c("2020-01-10", "2020-01-10 04:00:00")
#'   ),
#'   options = list(
#'     editable = TRUE,
#'     snap = htmlwidgets::JS("function (date, scale, step) {
#'          var hour = 60 * 60 * 1000;
#'          return Math.round(date / hour) * hour;
#'      }")
#'   )
#' )
#'
#' #----------------------- Using groups -----------------
#' timevis(data = data.frame(
#'   start = c(Sys.Date(), Sys.Date(), Sys.Date() + 1, Sys.Date() + 2),
#'   content = c("one", "two", "three", "four"),
#'   group = c(1, 2, 1, 2)),
#'   groups = data.frame(id = 1:2, content = c("G1", "G2"))
#'  )
#'
#' #----------------------- Using nested groups --------------------
#' timevis(
#'   data = data.frame(
#'     start = c("2022-01-01", "2022-01-02", "2022-01-03", "2022-01-04", "2022-01-05"),
#'     content = c("item 1", "item 2", "item 3", "item 4", "item 5"),
#'     group = 1:5
#'   ),
#'   groups = data.frame(
#'     id = 1:5,
#'     content = c("John", "Lee", "Clean", "Cook", "Shop"),
#'     nestedGroups = I(list(c(3, 4), 5, NA, NA, NA))
#'   )
#' )
#' }
#'
#' #----------------------- Getting data out of the timeline into Shiny -----------------
#' if (interactive()) {
#' library(shiny)
#'
#' data <- data.frame(
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
#'       data,
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
#' @seealso \href{https://daattali.com/shiny/timevis-demo/}{Demo Shiny app}
#' @export
timevis <- function(data, groups, showZoom = TRUE, zoomFactor = 0.5, fit = TRUE,
                    options = list(), width = NULL, height = NULL, elementId = NULL,
                    loadDependencies = TRUE, timezone = NULL) {

  # Validate the input data
  if (missing(data)) {
    data <- data.frame()
  }
  if (crosstalk::is.SharedData(data)) {
    crosstalk_opts <- list(
      key = data$key(),
      group = data$groupName()
    )
    data <- data$origData()

    if ("id" %in% names(data) && !isTRUE(all.equal(data$id, crosstalk_opts$key))) {
      warning("timevis: the `id` column of the data was overwritten by the SharedData key.")
    }
    data$id <- crosstalk_opts$key
  } else {
    crosstalk_opts <- NULL
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
  if (!missing(groups) && !is.data.frame(groups)) {
    stop("timevis: 'groups' must be a data.frame",
         call. = FALSE)
  }
  if (!missing(groups) && nrow(groups) > 0 &&
      (!"id" %in% colnames(groups) || !"content" %in% colnames(groups) )) {
    stop("timevis: 'groups' must contain a 'content' and 'id' variables",
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
  if (!is.bool(fit)) {
    stop("timevis: 'fit' must be either 'TRUE' or 'FALSE'",
         call. = FALSE)
  }
  if (is.null(options)) {
    options <- list()
  }
  if (!is.list(options)) {
    stop("timevis: 'options' must be a named list",
         call. = FALSE)
  }
  if (!is.null(timezone)) {
    if (!is.numeric(timezone) || length(timezone) != 1 ||
        timezone < -15 || timezone > 15) {
      stop("timevis: 'timezone' must be a number between -15 and 15",
           call. = FALSE)
    }
  }

  if (!"id" %in% names(data)) {
    data$id <- row.names(data)
  }

  items <- dataframeToD3(data)
  if (missing(groups)) {
    groups <- NULL
  } else {
    groups <- dataframeToD3(groups)
  }

  if (!is.null(options[["start"]]) || !is.null(options[["end"]])) {
    fit <- FALSE
  }

  # forward options using x
  x = list(
    items = items,
    groups = groups,
    showZoom = showZoom,
    zoomFactor = zoomFactor,
    fit = fit,
    options = options,
    height = height,
    timezone = timezone,
    crosstalk = crosstalk_opts
  )

  # Allow a list of API functions to be called on the timevis after
  # initialization
  x$api <- list()

  deps <- NULL

  if (!is.null(crosstalk_opts)) {
    deps <- crosstalk::crosstalkLibs()
  }
  # add dependencies so that the zoom buttons will work in non-Shiny mode
  if (loadDependencies) {
    deps <- append(
      deps,
      list(
        rmarkdown::html_dependency_jquery(),
        rmarkdown::html_dependency_bootstrap("default")
      )
    )
  }

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
#' #----------------------- Most basic example -----------------
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
#' #----------------------- More advanced example -----------------
#' data <- data.frame(
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
#'       data,
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
