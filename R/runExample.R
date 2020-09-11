#' Run examples of using timevis in a Shiny app
#'
#' This example is also
#' \href{https://daattali.com/shiny/timevis-demo/}{available online}.
#'
#' @examples
#' if (interactive()) {
#'   runExample()
#' }
#' @export
runExample <- function() {
  appDir <- system.file("example", package = "timevis")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `timevis`.",
         call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
