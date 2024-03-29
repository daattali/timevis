.onLoad <- function(libname, pkgname) {
  # register a handler to decode the timeline data passed from JS to R
  # because the default way of decoding it in shiny flattens a data.frame
  # to a vector
  shiny::registerInputHandler("timevisDF", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)
}

# Check if an argument is a single boolean value
is.bool <- function(x) {
  is.logical(x) && length(x) == 1 && !is.na(x)
}

# Convert a data.frame to a list of lists (the data format that D3 uses)
dataframeToD3 <- function(df) {
  if (missing(df) || is.null(df)) {
    return(list())
  }
  if (!is.data.frame(df)) {
    stop("timevis: the input must be a dataframe", call. = FALSE)
  }
  df <- as.data.frame(df)
  row.names(df) <- NULL
  lapply(seq_len(nrow(df)), function(row) {
    row <- df[row, , drop = FALSE]
    row_not_na <- row[, !is.na(row), drop = FALSE]
    lapply(row_not_na, function(x) {
      if (!lengths(x)) return(NA)
      if (is.logical(x)) return(x)
      if (lengths(x) > 1 | is.list(x)) return(lapply(unlist(x),as.character))
      return(as.character(x))
    })
  })
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
