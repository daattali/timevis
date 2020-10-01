context("dataframeToD3")

test_that("dataframeToD3 works with no input", {
  expect_identical(dataframeToD3(), list())
  expect_identical(dataframeToD3(data.frame()), list())
})

test_that("dataframeToD3 works with a single row", {
  df <- data.frame(name = "Dean", age = 27, stringsAsFactors = FALSE)
  list <- list(list(name = "Dean", age = "27"))
  expect_identical(dataframeToD3(df), list,
                   info = info_comp(dataframeToD3(df), list))
})

test_that("dataframeToD3 works with multiple rows", {
  df <- data.frame(name = c("Dean", "Ben"), age = c(27, 24))
  list <- list(list(name = "Dean", age = "27"),
               list(name = "Ben", age = "24"))
  expect_identical(dataframeToD3(df), list,
                   info = info_comp(dataframeToD3(df), list))
})

test_that("dataframeToD3 works with NA values", {
  df <- data.frame(name = c("Dean", "Ben"), age = c(27, 24), degree = c("MSc", NA))
  list <- list(list(name = "Dean", age = "27", degree = "MSc"),
               list(name = "Ben", age = "24"))
  expect_identical(dataframeToD3(df), list,
                   info = info_comp(dataframeToD3(df), list))
})

test_that("dataframeToD3 errors when given a non-dataframe", {
  expect_error(dataframeToD3(50), "input must be a dataframe")
  expect_error(dataframeToD3(FALSE), "input must be a dataframe")
})

test_that("dataframeToD3 returns the same whether the dataframe is pure or merged", {
  df <- data.frame(name = c("Dean", "Ben"), age = c(27, 24))
  df_rbind <- rbind(df[1, ], df[2, ])
  expect_identical(dataframeToD3(df), dataframeToD3(df_rbind),
                   info = info_comp(dataframeToD3(df), dataframeToD3(df_rbind)))
})


test_that("nested columns behave the way they ought to",{
  matts_hobbies <- c("Working", "thinking about work")
  df <- data.frame(name = c("Dean", "Matt"),
                   age = c(27, 23),
                   hobbies = c(NA, NA))
  df$hobbies[2] <- list(matts_hobbies)
  out <- dataframeToD3(df)
  expect <- list(list(name = "Dean", age = "27"),
                 list(name = "Matt", age = "23", hobbies = as.list(matts_hobbies)))
  expect_identical(out, expect, info = info_comp(out, expect))

  df2 <- df
  expect2 <- expect

  deans_hobby <- "Responding to pull requests"
  df2$hobbies[[1]] <- list(deans_hobby)
  expect2[[1]]$hobbies <- list(deans_hobby)
  out2 <- dataframeToD3(df2)
  expect_identical(out2, expect2, info = info_comp(out2, expect2))

  df3 <- df2
  expect3 <- expect2
  expect3[[1]]$hobbies <- NA

  df3$hobbies[[1]] <- list()
  out3 <- df3 %>% dataframeToD3()
  expect_identical(out3, expect3, info = info_comp(out3, expect3))
})
