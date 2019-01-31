# Produce a more informative output when failing expect_equivalent/identical
# testcases for visual comparison
info_comp <- function(actual, expect){
  if (!requireNamespace("glue", quietly = TRUE)){
    return()
  }
  out <- glue::glue("Expect: {expect}",
                    "Actual: {actual}", .sep = "\n")
  return(out)
}
