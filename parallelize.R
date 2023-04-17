library(doParallel)​

cl <- makeCluster(4)​

registerDoParallel(cl)​

data(iris)​

x <- iris[which(iris[,5] != "setosa"), c(1,5)]​

trials <- 10000​

​

# Basic loop​

base_loop <- system.time({​

  r <- for (i in 1:trials){​

    ind <- sample(100, 100, replace=TRUE)​

    result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))​

    irioutdf <- rbind(outdf,coefficients(result1))​

  }​

})​

​

# %do% loop - foreach notation, but not parallel​

do_loop <- system.time({​

r <- foreach(1:trials, .combine=rbind) %do% {​

  ind <- sample(100, 100, replace=TRUE)​

  result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))​

  coefficients(result1)​

}​

})​

​

# %dopar% adds parallelization​

dopar_loop <- system.time({​

r <- foreach(1:trials, .combine=rbind) %dopar% {​

  ind <- sample(100, 100, replace=TRUE)​

  result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))​

  coefficients(result1)​

}​

})​

​

print(rbind(base_loop,do_loop,dopar_loop)[,1:3])​

stopCluster(cl)​

​
