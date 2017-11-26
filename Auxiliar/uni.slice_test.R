# FUNCTION TO TEST THE UNI.SLICE FUNCTION.  
#
# Produces Postscript plots in slice-test.ps, one page per test, with the
# tests described in the code below.  
#
# Each test applies a series of univariate slice sampling updates (ss*thin of 
# them) to some distribution, starting at a point drawn from that distribution,
# with particular settings of the slice sampling options.  The page for a 
# test contains the following:
# 
#   - a trace plot of the results (at every 'thin' updates)
#   - a plot of the autocorrelations for this trace
#   - a plot of the bivariate distribution before and after 'thin' updates
#   - a qqplot of the sample produced vs. a correct sample
#   - the average number of evaluations per call
#   - the result of a t test for the sample mean vs. the correct mean, based
#     on 200 equally spaced points from the sample generated (which are
#     presumed to be virtually independent)

rm(list=ls())

# -------------
#	code
# -------------
source('uni.slice.R')

# -------------
#	Functions
# -------------

# Function to do the slice sampling updates.  
updates <- function (x0, g, reuse=FALSE){ 
    uni.slice.calls <- 0
    uni.slice.evals <- 0

    s <<- numeric(ss)
    x1 <- x0
    s[1] <<- x0
    last.g <- NULL

    for (i in 2:ss)
    { for (j in 1:thin)
      { if (reuse)
        { x1 <- uni.slice (x1, g, w=w, m=m, lower=lower, upper=upper, 
                           gx0=last.g)
          last.g <- attr(x1,"log.density")
          uni.slice.calls <- uni.slice.calls + attr(x1,"uni.slice.calls")
          uni.slice.evals <- uni.slice.evals + attr(x1,"uni.slice.evals")
        }
        else
        { x1 <- uni.slice (x1, g, w=w, m=m, lower=lower, upper=upper)
        }
      }
      s[i] <<- x1
    }
  }

# Function to display the results.
display <- function (r,mu,test){ 
    plot(s,type="p",xlab="Iteration",ylab="State",pch=20)

    title (paste( test, "  ss =",ss," thin =",thin))

    acf (s, lag.max=length(s)/20, main="")

    title (paste ("w =",w," m =",m," lower =",lower," upper =",upper))

    plot(s[-1],s[-length(s)],pch=20,xlab="Current state",ylab="Next state")

    title (paste ("Average number of evaluations:",
                   round(uni.slice.evals/uni.slice.calls,2)))

    qqplot(r,s,pch=".",
       xlab="Quantiles from correct sample",
       ylab="Quantiles from slice sampling")
    abline(0,1)

    p.value <- t.test (s[seq(1,length(s),length=200)]-mu) $ p.value
    title (paste ("P-value from t test:",round(p.value,3)))
  }  

# -----------------
#	Examples
# -----------------

# Standard normal, m = Inf.
set.seed(1)

ss <- 2000
thin <- 3
w <- 1.5
m <- Inf
lower <- -Inf
upper <- +Inf

undates_1 <- updates(rnorm(1), function(x) -x^2/2 )
display (rnorm(ss),0,"Standard normal")

# Standard normal, reusing density, m = Inf.
set.seed(1)

ss <- 2000
thin <- 3
w <- 1.5
m <- Inf
lower <- -Inf
upper <- +Inf

updates_2 <- updates (rnorm(1), function(x) -x^2/2, reuse=TRUE)
display (rnorm(ss),0,"Standard normal, reusing density")

# Normal mixture, m = 1.
set.seed(1)

ss <- 2000
thin <- 3
w <- 2.2
m <- 1
lower <- -Inf
upper <- +Inf

updates_3 <- updates (rnorm(1,-1,1), function(x) log(dnorm(x,-1,1)+dnorm(x,1,0.5)))
display (c (rnorm(floor(ss/2),-1,1), rnorm(ceiling(ss/2),1,0.5)), 0, "Normal mixture")

# Normal mixture, m = 3.
set.seed(1)

ss <- 2000
thin <- 3
w <- 1.8
m <- 3
lower <- -Inf
upper <- +Inf

update_4 <- updates (rnorm(1,-1,1), function(x) log(dnorm(x,-1,1)+dnorm(x,1,0.5)))
display (c (rnorm(floor(ss/2),-1,1), rnorm(ceiling(ss/2),1,0.5)), 0, "Normal mixture")

# Exponential, m = Inf.
set.seed(1)

ss <- 2000
thin <- 3
w <- 10
m <- Inf
lower <- 0
upper <- +Inf

update_5 <- updates (rexp(1), function(x) -x)
display (rexp(ss), 1, "Exponential")

# Exponential, m = 2.
set.seed(1)

ss <- 2000
thin <- 3
w <- 1.5
m <- 2
lower <- 0
upper <- +Inf

update_6 <- updates (rexp(1), function(x) -x)
display (rexp(ss), 1, "Exponential")

# Beta(0.5,0.8).
set.seed(1)

ss <- 2000
thin <- 3
w <- 1e9
m <- Inf
lower <- 0
upper <- 1

update7 <- updates (rbeta(1,0.5,0.8), function(x) dbeta(x,0.5,0.8,log=TRUE))
display (rbeta(ss,0.5,0.8), 0.5/(0.5+0.8), "Beta(0.5,0.8)")
  
#
#	-- END: uni.slice_test.R --