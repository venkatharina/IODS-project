#Chapter 6: Analysis of longitudinal data
#Date: 5.12.2023
#Katharina Ven  

#Data wrangling (max 5 points)

#loading data in:
library(readr)
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header=T)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")

#checking data:
colnames(BPRS)
#treatment, subject, week0, week1, week2, week3, week4, week5, week6, week7, week8
colnames(rats)
#ID, Group, WD1, WD8, WD15, WD22, WD29, WD36, WD43, WD44, WD50, WD57, WD64
str(BPRS)
str(rats)
#data with integer vectors
dim(BPRS) #40rows and 11variables
dim(rats) #16rows and 13variables
summary(BPRS)
summary(rats)

#in BPRS: are 40 male subjects were randomly assigned to one of two treatment groups 
#and each subject was rated on the brief psychiatric rating scale (BPRS) 
#measured before treatment began (week 0) and then at weekly intervals for 
#eight weeks. The BPRS assesses the level of 18 symptom constructs such as 
#hostility, suspiciousness, hallucinations and grandiosity; each of these is 
#rated from one (not present) to seven (extremely severe).

#in rats: Body Weights of Rats Recorded Over a 9-Week Period with different diets,
#diet options from 1-3

#convert the categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

#converting the data sets to long form and adding week variable to BPRS
#and adding time variable to rats 
BPRS_long <- pivot_longer(BPRS, cols = -c(treatment, subject), 
                          names_to = "weeks", values_to = "BPRS") %>% 
  arrange(weeks) %>% #order by weeks variable
  mutate(week=as.integer(substr(weeks,5,5)))
rats_long <- pivot_longer(rats, cols = -c(ID, Group), 
                          names_to = "wd", values_to = "weight") %>% 
  mutate(Time = as.integer(substr(wd,3,4))) %>% 
  arrange(Time) #order by time variable

dim(BPRS_long) #360rows and 5variables
dim(rats_long) #176rows and 5variables
colnames(BPRS_long) #treatment, subject, weeks, BPRS, week
colnames(rats_long) #ID, Group, wd, weight, time 
summary(BPRS_long)
summary(rats_long)
#in long form: all BPRS/weight reading are in one column
#in short form: each had their own column for each timepoint
write_csv(x=rats_long, 'ratslong.csv', col_names = TRUE)
write_csv(x=BPRS_long, 'BPRSlong.csv', col_names = TRUE)