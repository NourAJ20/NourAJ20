# R Advanced Course 
# Part 1 

getwd()
setwd("/Users/nouraantabli/Desktop/SNHU/Data Stuff/R Advanced Udemy Course")
getwd()

#Basic: fin <- read.csv("P3-Future-500-The-Dataset.csv")
fin <- read.csv("P3-Future-500-The-Dataset.csv", na.strings=c(""))

head(fin)
tail(fin)
str(fin)
summary(fin)

# ---------------------------------------- Refresher on Factors 

# Correct a non-factor to a factor (ID and Inception rows)


fin$ID
factor(fin$ID)
#Make a new factor variable for ID 
fin$ID <- factor(fin$ID)
summary(fin)

fin$Inception
factor(fin$Inception)
fin$Inception <- factor(fin$Inception) #The only step you need 
summary(fin)
str(fin)

# ---------------------------------------- The Factor Variable Trap (FVT)

#Example 
a <- c("12", "13", "14", "12", "12")
a
# the "" means they are being stored as characters not numerics 
typeof(a)
# how to convert to a numeric vector 

b <- as.numeric(a)
b
typeof(b) #double = numeric 

#--------------converting factors into numerics 

z <- c("12", "13", "14", "12", "12")
z <- factor(c("12", "13", "14", "12", "12"))
z
y <- as.numeric(z) #1 2 3 1 1 --- the way they are coding according to R 
y
typeof(y) #double

# -----------------Avoid the FVT 
#Convert z into a character first 
as.character(z)
x <- as.numeric(as.character(z))
x
typeof(x) #double

#Another Example FVT 

head(fin)
str(fin)
#fin$Profit <- factor(fin$Profit) -- Dangerous for data 

str(fin)
#Now profit is being recognized as a factor 
summary(fin)
#Convert profit into a nonfactor 
#fin$Profit <- as.numeric(fin$Profit) -- Dangerous for data (for learning sake)
str(fin)

head(fin)
#dont use profit (use Profit)
summary(fin)

# ------------------------------------------ gsub() & sub()

?sub
?gsub
# gsub -- replace dollar signs, commas, and percentage signs 
fin$Expenses <- gsub("Dollars", "", fin$Expenses) #Dollar text is replaced with "" nothing 
head(fin)

fin$Expenses <- gsub(",", "", fin$Expenses) #Removing commas in expenses
head(fin)

# fin$Revenue <- gsub("$", "", fin$Revenue)
# ^ This will not work because $ is a special character in R 
#You need to create an escape sequence for $ = \\$ 

fin$Revenue <- gsub("\\$", "", fin$Revenue)
fin$Revenue <- gsub(",", "", fin$Revenue)
head(fin)
str(fin)
# Revenue and Expenses are now chr meaning we can turn them into numerics soon 


fin$Growth <- gsub("%", "", fin$Growth)
head(fin)

# Now we can convert from chr to numeric (Easier and effective way)

fin$Expenses <- as.numeric(fin$Expenses)
fin$Revenue <- as.numeric(fin$Revenue)
fin$Growth <- as.numeric(fin$Growth)

head(fin)
str(fin)

# -------------------------------------------- Missing Data 

#What is NA 
TRUE #1 
FALSE #0 
NA 

# -------------------- How to locate missing data?

head(fin, 24)
#How to pull out the rows with NA or are left empty: use function complete.cases 

complete.cases(fin)
fin[!complete.cases(fin),]
# The output shows 6 rows that are not complete. This shows NA. The rows that show blank columns are not counted. 
# So now we have to go back and fil the empty spaces with NA 
# Go back to the begining when the file was read and add the following; 

#fin <- read.csv("P3-Future-500-The-Dataset.csv", na.strings=c(""))

head(fin, 20)
#Now once empty columns are now filled with <NA>

fin[!complete.cases(fin),]
head(fin, 20)

# ------------------ Filter data frame using which() for non-missing data 

head(fin)

fin$Revenue == 9746272
fin[fin$Revenue == 9746272,]

#How to deal with the extra NA that are in the output, which() ignores NA

which(fin$Revenue == 9746272)
fin[which(fin$Revenue == 9746272),]

#Example 
head(fin)

fin[fin$Employees == 45,]
fin[which(fin$Employees == 45),] #No NA

#------- Filtering with is.na()

head(fin, 20)

#fin$Expenses == NA
#fin[fin$Expenses == NA,] #You cannot compare anything to NA 

#use is.na()

is.na(fin$Expenses)
#Obtain the rows that have NA in the expenses column 
fin[is.na(fin$Expenses),]

fin[is.na(fin$State),]
fin[is.na(fin$Profit),]

# -------- Removing Records with Missing Data 
#Create a backup 
fin_backup <- fin

fin[!complete.cases(fin),] #all rows that have empty columns 
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),] #! means is not, therefor !is.na means is not empty 
fin <- fin[!is.na(fin$Industry),]
fin #rows with empty columns are removed 

# -------------------------- Reset the dataframe index 
#fix the row numbers 

rownames(fin) <- 1:nrow(fin) #Show how many rows you have in fin 
fin
rownames(fin) <- NULL #reset row names 
fin
head(fin, 20)

#--------------------------------------Factual analysis _ Replace missing data 

fin[!complete.cases(fin),] #that are not complete cases 

fin[is.na(fin$State),] #Checking missing values in State 

#Fill them in 

fin[is.na(fin$State) & fin$City=="New York",]
fin[is.na(fin$State) & fin$City=="New York", "State"] <- "NY"
fin[c(11,377),] #Check 

fin[is.na(fin$State) & fin$City== "San Francisco",]
fin[is.na(fin$State) & fin$City=="San Francisco", "State"] <- "CA"
fin[c(82,265),] #Check 

# -------------------- Replace missing data with Median 

median(fin[,"Employees"], na.rm=TRUE)
mean(fin[,"Employees"], na.rm=TRUE)

#Check median for the retail industry the save the value so you dont override existing data
med_empl_retail <- median(fin[fin$Industry=="Retail", "Employees"], na.rm = TRUE) 
med_empl_retail

#Now put the value of the median (28) in the empty row 
fin[is.na(fin$Employees) & fin$Industry == "Retail",]
fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- med_empl_retail

#Check 
fin[3,]

median(fin[,"Employees"], na.rm=TRUE)
median(fin[fin$Industry == "Financial Services","Employees"], na.rm=TRUE)

med_empl_Financialservises <- median(fin[fin$Industry == "Financial Services","Employees"], na.rm=TRUE)
med_empl_Financialservises

fin[is.na(fin$Employees) & fin$Industry == "Financial Services", "Employees"] <- med_empl_Financialservises
fin[330,]

#Check what other rows are incomplete 
fin[!complete.cases(fin),]
# 4 more rows left with NA 

names(fin)


# --------------------------- Part 2 - Replace missing data, median imputation method 
fin[!complete.cases(fin),]

median_growth_construction <- median(fin[fin$Industry == "Construction","Growth"], na.rm=TRUE)
median_growth_construction

fin[is.na(fin$Growth) & fin$Industry=="Construction",]
fin[is.na(fin$Growth) & fin$Industry=="Construction", "Growth"] <- median_growth_construction
fin[8,]

median(fin[fin$Industry=="Construction", "Revenue"], na.rm = TRUE)
median_revenue_Construction <- median(fin[fin$Industry=="Construction", "Revenue"], na.rm = TRUE)
median_revenue_Construction
fin[is.na(fin$Revenue) & fin$Industry == "Construction",]
fin[is.na(fin$Revenue) & fin$Industry == "Construction", "Revenue"] <- median_revenue_Construction

fin[!complete.cases(fin),]

median_expenses_construction <- median(fin[fin$Industry=="Construction", "Expenses"], na.rm=TRUE)
median_expenses_construction

fin[is.na(fin$Expenses) & fin$Industry == "Construction" & is.na(fin$Profit),]
fin[is.na(fin$Expenses) & fin$Industry == "Construction" & is.na(fin$Profit), "Expenses"] <- median_expenses_construction

fin[!complete.cases(fin$Industry == "Profit"),]
fin[!complete.cases(fin),]

# ------------------------------ Next to fill in the Profit (Construction) and Expenses (IT Service)
# Revenue - Expenses = Profit 
# Expenses = Revenue - Profit 

fin[is.na(fin$Profit), "Profit"] <- fin[is.na(fin$Profit), "Revenue"] - fin[is.na(fin$Profit), "Expenses"]
fin[c(8,42),]

fin[!complete.cases(fin),]

fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]
fin[15,]
fin[!complete.cases(fin),] #Agreed to keep row 20 empty with Inception (NA) since it will not affect our analysis 

#Data Cleaning and filling empty rows is now done!! 
# --------------------------------------------------- Visualizing the results 
# We need a scatterplot classified by industry showing revenue, expenses, and profit 
# A scatter plot that includes trends for the expenses-revenue relationship 
# A Boxplot showing growth by industry 

library(ggplot2)

p <- ggplot(data=fin)
p + geom_point(aes(x = Revenue, y = Expenses, 
                   colour = Industry, size = Profit))

# ------- Trends for expenses-revenue relationship (scatterplot)

d <- ggplot(data = fin, aes(x = Revenue, y = Expenses, colour = Industry))

d + geom_point() + 
  geom_smooth(fill = NA, size = 1.2)

# ------ Boxplot 

f <- ggplot(data=fin, aes(x=Industry, y=Growth, 
                           colour = Industry))

f + geom_boxplot(size = 1)

#Extra: 
f + geom_jitter() + 
  geom_boxplot(size = 1, alpha = 0.5, outlier.color = NA)



















































