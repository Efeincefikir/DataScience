library(tidyverse)
library(stringr)
set.seed(2018556453)

#Question 1


testArray= c(89, 107, 597, 931, 1083)
primeChecker <- function(x) {
  primeNumbers= c()
  nonPrimeNumbers= c()
  primeFactors = c()
  for(i in x) {
    if (i == 2) {
      primeNumbers <- c(primeNumbers, i) 
    } else if (any(i %% 2:(i-1) == 0)) {
      
      
      nonPrimeNumbers <- c(nonPrimeNumbers,i)
      if (i > 2) {
        primeFactors <- numeric()
        while(i %% 2 == 0){
          primeFactors = c(primeFactors, 2)
          i = i/2
        }
        n = 3
        while(i != 1) {
          while(i %% n == 0) {
            primeFactors = c(primeFactors, n)
            i = i/n
          }
          n = n + 2
        }
      }
      
      nonPrimeNumbers <- c(nonPrimeNumbers,"[" ,primeFactors, "]")
      
    } else { 
      primeNumbers <- c(primeNumbers, i)
    }
    
  }
  cat( "prime numbers:" , primeNumbers, "\n")
  cat( "non-prime numbers:" , nonPrimeNumbers)
}

primeChecker(testArray)


#Question 2
stringr::sentences
wordOrderFunc <- function(x) {
  sample2 <- x %>%
    str_split(" ") %>%
    simplify() %>%
    unique()
  

  sample2<-str_to_lower(sample2)
  sample2<-str_replace_all(sample2,"[,.']","")

  
  sample2[order(nchar(sample2), sample2)]
  
  
}
smpl<-sample(sentences,size=5)
wordOrderFunc(smpl)


