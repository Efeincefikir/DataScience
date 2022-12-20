library(tidyverse)
set.seed(2018556453)

library(stringr)
stringr::sentences

#First Question
smpl<-sample(sentences,size=100)
view(smpl)

sample2 <- smpl %>%
  str_split(" ") %>%
  simplify() %>%
  unique()
view(sample2)

#Second Question
str_view(sample2, "e$", match=TRUE)
part2SecondQuestion <-str_view(sample2, "^a.*e$", match=TRUE)
part2SecondQuestion

#Third Question
vowel <- str_count(sample2, "^(.[aeuio].*){3,}$")
vowel
part2ThirdQuestion <- sum(vowel == 1)
part2ThirdQuestion

#Fourth Question


str_length(sample2)
temp3 <- order(str_length(sample2), decreasing = TRUE)
sample2[temp3]
fourth_result<-head(sample2[temp3], 5)
fourth_result

#Fifth Question
part2FifthQuestion<- sample2[str_detect(sample2, "her|any|day|exp|age|pro|the")]
part2FifthQuestion

