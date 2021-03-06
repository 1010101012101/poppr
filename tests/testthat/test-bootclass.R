context("bootclass methods")

data("nancycats", package = "adegenet")
nan9 <- nancycats[pop = 9]
nanreps <- structure(c(1.99999, 2, 1.99999, 2, 2, 2, 1.99999, 1.99999, 2
), .Names = c("fca8", "fca23", "fca43", "fca45", "fca77", "fca78", 
"fca90", "fca96", "fca37"))
bgnan <- new("bootgen", nan9, na = "asis", freq = FALSE)
bvnan <- new("bruvomat", nan9, nanreps)

test_that("an empty bootgen can be initialized", {
  expect_is(new("bootgen"), "bootgen")
})

test_that("an empty bruvomat can be initialized", {
  expect_is(new("bruvomat"), "bruvomat")
})

test_that("bruvomat will guess repeat lengths if given none", {
  skip_on_cran()
  expect_is(new("bruvomat", nan9), "bruvomat")
})

test_that("bootgen throws an error if a non-gen object is passed", {
  expect_error(new("bootgen", nanreps), 
               gettext("gen must be a valid genind or genpop object", domain = "R"))
})

test_that("bootgen can be initialized from a genppop", {
  skip_on_cran()
  expect_is(new("bootgen", genind2genpop(nancycats, quiet = TRUE)), "bootgen")
})
test_that("bootgen can be subset correctly without loci specified", {
  expect_identical(bgnan[], bgnan)
})

test_that("bruvomat can be subset correctly without loci specified", {
  expect_equivalent(bvnan[], bvnan)
})

test_that("bootgen throws an error if given out-of-bounds subscripts", {
  expect_error(bgnan[, 10], gettext("subscript out of bounds", domain = "R"))
})

test_that("bruvomat can be subset correctly without loci specified", {
  subafter <- bvnan@mat[, rep((1:9) %% 2 == 1, each = 2)]
  subfore  <- bvnan[, (1:9) %% 2 == 1]@mat
  dimnames(subafter) <- NULL -> dimnames(subfore)
  expect_equivalent(subfore, subafter)
})

test_that("dist works with bootgen", {
  skip_on_cran()
  expect_is(dist(bgnan), "dist")
})