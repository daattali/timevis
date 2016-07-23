#' Run examples of using timelinevis in a Shiny app
#'
#' This example is also
#' \href{http://daattali.com/shiny/timelinevis-demo/}{available online}.
#'
#' @examples
#' if (interactive()) {
#'   runExample()
#' }
#' @export
runExample <- function() {
  appDir <- system.file("example", package = "timelinevis")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `timelinevis`.",
         call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
