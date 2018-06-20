source("V:/PwC Predictor/PAS-Server-Aktuell/lagFunctions.R")
# Falls das Packages "testthat" noch nicht installiert wurde
# install.packages("testthat")
library("testthat")

context("Functions in lagFunctions.R")

context("calculate.data.lags")


data.for.test.of.lags <- function(nr.of.observations)
{
    #Setup examples for dependent and independent data
    independent.data <- data.frame(A=c(1:nr.of.observations),B=c(11:(10+nr.of.observations)))
    dependent.data <- c(101:(100+nr.of.observations))

    return(list(independent.data= independent.data, dependent.data = dependent.data))
}


index.of.useable.observation <- function(nr.of.observations, lag.vec)
{
        #Given the lag.vec, we can not use all observations of the dependent variable:
        #If a  time series of an independent variable has a positive lag we have to drop observations from the beginning of time series of the dependent var, since we have not enough historic data (of the independent variable); if a time series of an independent variable has a negative lag we have to drop observations at the end of the dependent variable,  since we can not look far enough into the futur of the indepentend variable.
    

    first.useable.observation <- max(1+max(lag.vec), 1)
    last.useable.observation <- min(nr.of.observations, nr.of.observations+min(lag.vec))

    return(seq(from=first.useable.observation,to=last.useable.observation, by=1))
}

test_that("calculate.data.lags() output has expected column names (at least not temp!)", {
    nr.of.observations <- 8

    test.data.set <- data.for.test.of.lags(nr.of.observations)

    lag.vec <- c(0,0)

    
    shifted <- calculate.data.lags(lag.vec, max(lag.vec), min(lag.vec), test.data.set$independent.data, test.data.set$dependent.data)
    shifted.ind <- shifted[[1]]
    
    expect_that(colnames(shifted.ind), is_equivalent_to(c('A','B')))
    
})

test_that("the output of calculate.data.lags() is a valide input for it as well", {
    nr.of.observations <- 8

    test.data.set <- data.for.test.of.lags(nr.of.observations)

    lag.vec <- c(1,1)

    
    shifted <- calculate.data.lags(lag.vec, max(lag.vec), min(lag.vec), test.data.set$independent.data, test.data.set$dependent.data)
    shifted.ind <- shifted[[1]]
    shifted.dep <- shifted[[2]]

    twice.shifted <- calculate.data.lags(c(0,0), 0, 0, shifted.ind, shifted.dep)#Note that c(0,0) is a special case
    expect_that(1, is_equivalent_to(1))
})


test_that("calculate.data.lags() correctly shifts dependent and independent data, given  lag.vec is  in list(c(0,0), c(2,3), c(-2,3), c(2,-3), c(-2,-3))", {
    nr.of.observations <- 8

    test.data.set <- data.for.test.of.lags(nr.of.observations)
    
    list.of.lag.vecs <- list(c(0,0), c(2,3), c(-2,3), c(2,-3), c(-2,-3))
    for(i in c(1:length(list.of.lag.vecs)))
    {
        lag.vec <- list.of.lag.vecs[[i]]

        useable.observation <- index.of.useable.observation(nr.of.observations, lag.vec)
        first.useable.observation <- min(useable.observation )
        last.useable.observation <- max(useable.observation)
        
        nr.useable.observation <- length(useable.observation)
        
        
        shifted <- calculate.data.lags(lag.vec, max(lag.vec), min(lag.vec), test.data.set$independent.data, test.data.set$dependent.data)
        shifted.ind <- shifted[[1]]
        shifted.dep <- shifted[[2]]

                                        #Correct dimension
        expect_that(nrow(shifted.ind), is_equivalent_to(nr.useable.observation))
        expect_that(length(shifted.dep ), is_equivalent_to(nr.useable.observation))

                                        #Correct entries
                                        #This expectations follow from our defintitions in  data.for.test.of.lags(nr.of.observations)
        expect_that(shifted.dep[1],is_equivalent_to(100+first.useable.observation))
        expect_that(shifted.ind[1,1],is_equivalent_to(first.useable.observation-lag.vec[1]))
        expect_that(shifted.ind[1,2],is_equivalent_to(10+first.useable.observation-lag.vec[2]))
        
        shifted <- 0
    }
})




test_that("calculate.data.lags has the correct dimension for small data sets", {
    #Parameters
    nr.of.observations <- 5
    lag.vec <- c(2,3)

    #Setup
    test.data.set <- data.for.test.of.lags(nr.of.observations)  

    useable.observation <- index.of.useable.observation(nr.of.observations, lag.vec)
    first.useable.observation <- min(useable.observation )
    last.useable.observation <- max(useable.observation)
    nr.useable.observation <- length(useable.observation)
    
    
    shifted <- calculate.data.lags(lag.vec, max(lag.vec), min(lag.vec), test.data.set$independent.data, test.data.set$dependent.data)
    shifted.ind <- shifted[[1]]
    shifted.dep <- shifted[[2]]

    #Test that dimension is correct
    expect_that(nrow(shifted.ind), is_equivalent_to(nr.useable.observation))
    expect_that(length(shifted.dep ), is_equivalent_to(nr.useable.observation))
})

context("linear.regression.auto for bigData == FALSE")

data.for.test.of.regression.without.interaction <- function(nr.of.observations, noise=FALSE)
{
                                        #Setup examples for dependent and independent data
    independent.data <- data.frame(c(1:nr.of.observations))
    dependent.data <- c(101:(100+nr.of.observations))
    if (noise==TRUE)
    {
        set.seed(123)
        error.term <- rnorm(nr.of.observations)
        dependent.data  <- dependent.data + error.term
    }

    return(list(independent.data= independent.data, dependent.data = dependent.data))
}


data.for.test.of.regression.with.interaction <- function(nr.of.observations, noise=FALSE, coeff=c(0,2,9,-15))
{
        #Setup examples for dependent and independent data
    independent.data <- data.frame(A=sqrt(c(1:nr.of.observations)),B=c(-55:(nr.of.observations-56)))
    dependent.data <- coeff[1]+coeff[2]*independent.data$A+coeff[3]*independent.data$B +coeff[4]*(independent.data$A*independent.data$B)
    if (noise==TRUE)
    {
        set.seed(123)
        error.term <- rnorm(nr.of.observations)
        dependent.data  <- dependent.data + error.term
    }

    return(list(independent.data= independent.data, dependent.data = dependent.data))
}

test_that("linear.regression.auto can deal with  dependent.data passed as data frame",
{
    nr.of.observations <- 100

    test.data.set <- data.for.test.of.regression.without.interaction(nr.of.observations, noise=FALSE)
    result <- linear.regression.auto(test.data.set$independent.data, data.frame(test.data.set$dependent.data), 0, 0,FALSE)
    expect_that(result$coefficients, is_equivalent_to(c(100,1)))
})

test_that("linear.regression.auto  works in a noise free context",{
    nr.of.observations <- 100

    test.data.set <- data.for.test.of.regression.without.interaction(nr.of.observations, noise=FALSE)
    result <- linear.regression.auto(test.data.set$independent.data, test.data.set$dependent.data, 0, 0,FALSE)
    expect_that(result$coefficients, is_equivalent_to(c(100,1)))
})

test_that("linear.regression.auto  works in a noisy context",{
    nr.of.observations <- 100

    test.data.set <- data.for.test.of.regression.without.interaction(nr.of.observations, noise=TRUE)
    result <- linear.regression.auto(test.data.set$independent.data, test.data.set$dependent.data, 0, 0,FALSE)
    
    expect_equal(result$coefficients, c(100,1), tolerance=0.5,check.attributes=FALSE) # We allow a error margin of 1.
})

test_that("linear.regression.auto  deals with interactions correctly",
{
        nr.of.observations <- 10000

        test.data.set <- data.for.test.of.regression.with.interaction(nr.of.observations, noise=TRUE, coeff=c(0,2,9,-15))
        result <- linear.regression.auto(test.data.set$independent.data, test.data.set$dependent.data, TRUE, 0,FALSE)
        # expect_that(result$coefficients, is_equivalent_to(c(0,2,9,-15)))
        expect_equal(result$coefficients, c(0,2,9,-15), tolerance=0.05,check.attributes=FALSE)
})

context("regression.auto")

test_that("regression.auto actually uses doParallel",
{
    nr.of.observations <- 100
    
    test.data.set <- data.for.test.of.regression.without.interaction(nr.of.observations, noise=FALSE)
    result <- regression.auto(test.data.set$dependent.data, test.data.set$dependent.data, test.data.set$independent.data, 3, 0,FALSE)

    expect_that(getDoParWorkers(), is_equivalent_to(detectCores()))
})


test_that("lag.vec.frame is defined correctly",
{
    range <- 3
    nr.covariates <- 2
    lag.vec.frame <- expand.grid(rep(list(0:range), nr.covariates))

    nr.combinations <- (range+1)^nr.covariates
    expect_that(nrow(lag.vec.frame), is_equivalent_to(nr.combinations))
})

data.for.test.of.regression.auto <- function(nr.of.observations,lag.vec=c(0,0),coeff=c(0,2,9,-15))
{
    #We shift the data.for.test.of.regression.with.interaction(),
    #for shifting we will use calculate.data.lags
    #as shifting leads to losses of observations, we first determin this loss.
    #To shift the data such such that the lag structur is in accordance with lag.vec, we have to use -lag.vec.

    lost.observations <- nr.of.observations-length(index.of.useable.observation(nr.of.observations, -lag.vec))
    data.set.without.lags <- data.for.test.of.regression.with.interaction(nr.of.observations+lost.observations, noise=FALSE,coeff)
    shifted.data <- calculate.data.lags(-lag.vec, max(-lag.vec), min(-lag.vec), data.set.without.lags$independent.data, data.set.without.lags$dependent.data)
    colnames(shifted.data[[1]])=c('A','B') #Why not implemented in calculate.data.lags?
    
    return(list(independent.data= shifted.data[[1]], dependent.data = shifted.data[[2]]))
    
}

test_that("regression.auto selects the correct model",
{
    nr.of.observations <- 10^5
    lag.vec <- c(-1,1)
    coeff <- c(-100,0.001,3,-5)
    
    test.data.set <- data.for.test.of.regression.auto(nr.of.observations, lag.vec,coeff)
    result <- regression.auto(test.data.set$dependent.data, test.data.set$dependent.data, data.frame(test.data.set$independent.data), 3, 1,TRUE)
    
    expect_equal(max(result[[3]])-min(result[[3]]), max(lag.vec)-min(lag.vec), tolerance=0.5,check.attributes=FALSE) # We allow a error margin of 1.
})

# Random Kommentar und noch mehr