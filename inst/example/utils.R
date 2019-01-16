# generate a random string of 16 characters
randomID <- function() {
  paste(sample(c(letters, LETTERS, 0:9), 16, replace = TRUE), collapse = "")
}

prettyDate <- function(d) {
  if (is.null(d)) return()
  posix <- as.POSIXct(d, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
  corrected <- lubridate::with_tz(posix, tzone = Sys.timezone())
  format(corrected, "%Y-%m-%d %H:%M:%OS %Z")
}
