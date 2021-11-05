test_that("BINSEG returns a vector with the same number of elements as the number of segments", {
  expect_equal(length(BINSEG(iris[,1],3)), 3)
})
test_that("BINSEG returns the same loss values as binsegRcpp::binseg_normal",{
  expect_equal(BINSEG(iris[,1],3),binsegRcpp::binseg_normal(iris[,1],3)$loss)
})