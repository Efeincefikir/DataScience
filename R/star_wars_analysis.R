install.packages("tidyverse")
library(tidyverse)
view(starwars)

#First Question
list = filter(starwars,starships!= "character(0)")
list $ name

#Second Question
eye_frequency<-starwars %>%
  group_by(eye_color) %>%
  summarize(
    count= n()
    
  )
arrange(eye_frequency, desc(count))

#Third Question
no_null_list<-filter(starwars,birth_year !="N/A")
mean_age<-no_null_list %>%
  group_by(species) %>%
  summarize(
    mean_birth=mean(birth_year)
  )
a1<-arrange(mean_age,desc((mean_birth)))
head(a1,3)

 #Fourth Question 

 sw_character<-rbind(starwars,c("Efe İncefikir", 183, 95.0, "black","light","brown", 22, "male", "masculine", "Naboo", "Human","The Phantom Menace", "Snowspeeder" , "X-wing"))

 sw_character$height<- as.integer(sw_character$height)
 sw_character$mass<- as.double(sw_character$mass)
 view(sw_character)
 
#Fifth Question
 
sw_character<- mutate(sw_character, BMI= mass/ ((height/100)^2))
sw_character <-mutate(sw_character, weight_type= if_else(BMI< 18.5, "underweight", if_else(BMI <25, "healthy", if_else(BMI <30, "overweight", "obese"))))
view(sw_character)
#Sixth Question

sw_character$birth_year<-as.integer(sw_character$birth_year)
age_below_hundred<-filter(sw_character,birth_year<100.0)

ggplot(data=age_below_hundred)+
  geom_point(mapping=aes(x=birth_year,y=BMI))

#Seventh Question
ggplot(data=sw_character)+
  geom_point(mapping=aes(x=birth_year,y=BMI))+
  geom_smooth(mapping=aes(x=birth_year,y=BMI))

ggplot(data=age_below_hundred,mapping=aes(x=birth_year,y=BMI))+
  geom_point()+
  geom_smooth(data=filter(age_below_hundred,birth_year<100 & BMI<100))

