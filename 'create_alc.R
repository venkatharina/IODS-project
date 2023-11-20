#Chapter 3: Logistic regression
#Date: 13.11.2023
#Katharina Ven   
 
#Data wrangling (max 5 points) 

#reading the csv files into script:
math <- read.csv("student-mat.csv", sep = ';')
por<- read.csv("student-por.csv", sep= ';')
#viewing structures and dimensions of tables
dim(math) #395 observations  and 33 variables
dim(por) #649 observations and  33 variables
colnames(math)
colnames(por)
#column names listed from both tables
#both tables have same variables

#Joining data set by using all other variables than "failures", "paid", 
#"absences", "G1", "G2", "G3" as (student) identifiers:
#access the dplyr package
library(dplyr)
#naming columns not to use in joining
free_cols <- c("failures","paid","absences","G1","G2","G3")
#separting columns which to use in joining
join_cols <- setdiff(colnames(por), free_cols)
#joining datasets together with selected columns 'join_cols'
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))
#dimensions of table
dim(math_por) #370 observations and  39 variables

#getting rid of duplicate values with my own solution:
#checking first if there are duplicate rows in datatable
a <- duplicated(math_por)
summary(a)
#FALSE = there does not seem to be duplicate values?
#trying anyway to remove duplicate rows with unique nad distinct commands
aa <- unique(math_por)
dim(aa) #370 39
aaa <- distinct(math_por)
dim(aaa) #370 39
#after removing, still having same dimensions as in original table math_por
#assuming that there are no duplicate rows

library(dplyr); library(ggplot2)
#new column 'alc_use' with average of Dalc (workday alcohol consumption) 
#and Walc (weekend alcohol consumption)
math_por2 <- mutate(math_por, alc_use = (Dalc + Walc) / 2)
#new column 'high_use' and if alc_use average above 2 (>2), high_use=TRUE 
math_por3 <- math_por2 %>% mutate(income_na = if_else(alc_use > 2, TRUE, FALSE))

library(readr)
#glimpsing and saving joined and modified data
glimpse(math_por3)
dim(math_por3) #370 observations and  41 variables (+2 with two new columns we made)
write_csv(x=math_por3, 'math_por3.csv', col_names = TRUE)