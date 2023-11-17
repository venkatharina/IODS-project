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

#getting rid of duplicate values:
# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))
# print out the columns not used for joining (those that varied in the two data sets)
# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

library(dplyr); library(ggplot2)
#new column 'alc_use' with average of Dalc (workday alcohol consumption) 
#and Walc (weekend alcohol consumption)
math_por2 <- mutate(alc, alc_use = (Dalc + Walc) / 2)
#new column 'high_use' and if alc_use average above 2 (>2), high_use=TRUE 
math_por3 <- math_por2 %>% mutate(income_na = if_else(alc_use > 2, TRUE, FALSE))

library(readr)
#glimpsing and saving joined and modified data
glimpse(math_por3)
dim(math_por3) #370 observations and  35 variables
write_csv(x=math_por3, 'math_por3.csv', col_names = TRUE)