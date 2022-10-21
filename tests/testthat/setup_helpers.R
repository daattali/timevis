# Produce a more informative output when failing expect_equivalent/identical
# testcases for visual comparison
info_comp <- function(actual, expect){
  paste0(
    c("Expect: ", "Actual: "),
    c(expect, actual),
    collapse = "\n"
  )
}
