test_that("DYNPROG returns a matrix with the same number of rows as the input data set", {
  expect_equal(nrow(DYNPROG_interface(iris[,1],3)), length(iris[,1]))
})
test_that("DYNPROG returns the same changepoint as jointseg::Fpsn for the first segment",{
  jointseg.result<-jointseg::Fpsn(iris[,1],3)
  DYNPROG.result <- DYNPROG_interface(iris[,1],3)
  expect_equal(jointseg.result$t.est[1,1],which.min(DYNPROG.result[,1]))
})
