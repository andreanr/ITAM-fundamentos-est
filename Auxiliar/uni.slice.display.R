# Function to display the results.
uni.slice.display <- function (r,mu,test){ 
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


