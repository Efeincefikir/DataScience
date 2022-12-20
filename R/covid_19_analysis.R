library(tidyverse)
library(data.table)
database <- read.csv("C:\\R\\covid-data-2020.csv" ,sep= "\t" , header = TRUE )
view(database)
set.seed(2018556453)
sample <- database[sample(nrow(database), 1000) ,]
view(sample)

#First Question
firstQuestion <- sample %>%
  group_by(location,month) %>%
  summarize( min = min(new_cases), Q1= quantile( new_cases , 0.25, na.rm=TRUE) , Q2= quantile(new_cases, 0.50, na.rm=TRUE),
             Q3 = quantile(new_cases, 0.75, na.rm= TRUE), max= max(new_cases))

view(firstQuestion)

#Second Question

secondQuestion <- sample %>%
  group_by(location) %>%
  summarize( max_case = max(new_cases, na.rm= TRUE) , max_deaths = max(new_deaths,na.rm=TRUE))

view(secondQuestion)

#Third Question
temp <- sample %>%
  group_by(location, month) %>%
  summarize( mean_Cases = max(mean(new_cases, na.rm=TRUE)))

view(temp)
 temp2 <- arrange(temp, desc(mean_Cases))
view(temp2)
#Temp 2 Shpws the result at the top, but it also includes other months from locations
 row_to_keep <- c(!duplicated(temp2$location))
thirdQuestion <- temp2[row_to_keep, ]

view(thirdQuestion)

#Fourth Question

fourthQuestion<- filter(sample,location ==c("Turkey","Russia","France"))
ggplot(data=fourthQuestion,mapping=aes(x=month,y=new_cases,color=location)) +
  geom_smooth()

ggplot(data=fourthQuestion,mapping=aes(x=month,y=new_cases,color=location)) +
  geom_boxplot()

