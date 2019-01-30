
info_comp <- function(actual, expect){
  if (!requireNamespace("glue", quietly = TRUE)){
    return()
  }
  out <- glue::glue("Expect: {expect}",
                    "Actual: {actual}", .sep = "\n")
  return(out)
}
