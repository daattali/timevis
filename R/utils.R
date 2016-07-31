.onLoad <- function(libname, pkgname) {
  # register a handler to decode the timeline data passed from JS to R
  # because the default way of decoding it in shiny flattens a data.frame
  # to a vector
  shiny::registerInputHandler("timevisDF", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  })
}

# Check if an argument is a single boolean value
is.bool <- function(x) {
  is.logical(x) && length(x) == 1
}

# Convert a data.frame to a list of lists (the data format that D3 uses)
dataframeToD3 <- function(df) {
  if (missing(df) || is.null(df)) {
    return(list())
  }
  apply(df, 1, function(row) as.list(row[!is.na(row)]))
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
