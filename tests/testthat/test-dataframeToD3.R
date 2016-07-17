context("dataframeToD3")

test_that("dataframeToD3 works with no input", {
  expect_identical(dataframeToD3(), list())
  expect_identical(dataframeToD3(data.frame()), list())
})

test_that("dataframeToD3 works with a single row", {
  df <- data.frame(name = "Dean", age = 27, stringsAsFactors = FALSE)
  list <- list(list(name = "Dean", age = "27"))
  expect_identical(dataframeToD3(df), list)
})

test_that("dataframeToD3 works with multiple rows", {
  df <- data.frame(name = c("Dean", "Ben"), age = c(27, 24))
  list <- list(list(name = "Dean", age = "27"),
               list(name = "Ben", age = "24"))
  expect_identical(dataframeToD3(df), list)
})

test_that("dataframeToD3 works with NA values", {
  df <- data.frame(name = c("Dean", "Ben"), age = c(27, 24), degree = c("MSc", NA))
  list <- list(list(name = "Dean", age = "27", degree = "MSc"),
               list(name = "Ben", age = "24"))
  expect_identical(dataframeToD3(df), list)
})
