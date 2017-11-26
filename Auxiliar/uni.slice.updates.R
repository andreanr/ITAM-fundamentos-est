# Function to do the slice sampling updates.  
uni.slice.updates <- function (x0, g, reuse=FALSE){ 
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
