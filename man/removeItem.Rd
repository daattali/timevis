% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{removeItem}
\alias{removeItem}
\title{Remove an item from a timeline}
\usage{
removeItem(id, itemId)
}
\arguments{
\item{id}{Timeline id or a \code{timevis} object (the output from \code{timevis()})}

\item{itemId}{The id of the item to remove}
}
\description{
Remove an item from a timeline
}
\examples{
\dontrun{
timevis(data.frame(start = Sys.Date(), content = c("1", "2"))) \%>\%
  removeItem(2)
}

if (interactive()) {
library(shiny)
shinyApp(
  ui = fluidPage(
    timevisOutput("timeline"),
    actionButton("btn", "Remove item 2")
  ),
  server = function(input, output) {
    output$timeline <- renderTimevis(
      timevis(data.frame(
        start = Sys.Date(), content = c("1", "2"))
      )
    )
    observeEvent(input$btn, {
      removeItem("timeline", 2)
    })
  }
)
}
}
