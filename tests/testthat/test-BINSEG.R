test_that("BINSEG returns a vector with the same number of elements as the number of segments", {
  expect_equal(length(BINSEG(iris[,1],3)), 3)
})