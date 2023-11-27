#Chapter 4: Clustering and classification
#Date: 27.11.2023
#Katharina Ven  

#Data wrangling (max 5 points)

library(readr)

#reading data in
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#checking data sets:
str(hd)
dim(hd) #195 rows and 8 columns
summary(hd) #summary of hd datatable
str(gii)
dim(gii) #195 rows and 10 columns
summary(gii) #summary of gii datatable

library(dplyr)

#renaming columns with shorter, and checking column names
hd <- hd %>% 
  rename(
    'HDI Rank' = 'HDI Rank',
    'Country' = 'Country',
    'HDI' = 'Human Development Index (HDI)',
    'Life.Exp' = 'Life Expectancy at Birth',
    'Edu.Exp' = 'Expected Years of Education',
    'Mean.Y.Edu' = 'Mean Years of Education',
    'GNI' = 'Gross National Income (GNI) per Capita',
    'GNI.HDI' = 'GNI per Capita Rank Minus HDI Rank'
    )
colnames(hd)
gii <- gii %>% 
  rename(
    'GII Rank' = 'GII Rank',
    'Country' = 'Country',
    'GII' = 'Gender Inequality Index (GII)',
    'Mat.Mor' = 'Maternal Mortality Ratio',
    'Ado.Birth' = 'Adolescent Birth Rate',
    'Parli.F' = 'Percent Representation in Parliament',
    'Edu2.F' = 'Population with Secondary Education (Female)',
    'Edu2.M' = 'Population with Secondary Education (Male)',
    'Labo.F' = 'Labour Force Participation Rate (Female)',
    'Labo.M' = 'Labour Force Participation Rate (Male)'
  )
colnames(gii)

#mutating more columns to "Gender inequality" data
gii2 <- mutate(gii, Edu2FM = (Edu2.F / Edu2.M))
gii3 <- mutate(gii2, LaboFM = (Labo.F / Labo.M))

#joining two dataset together
hd_gii3 <- inner_join(hd, gii3, by = 'Country')

#calling data as 'human'
human <- hd_gii3

library(readr)
#saving the data as 'human.csv'
write_csv(x=human, 'human.csv', col_names = TRUE)