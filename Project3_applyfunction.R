#Next section: Apply Function 
#Weather data 

getwd()
setwd("/Users/nouraantabli/Desktop/SNHU/Data Stuff/R Advanced Udemy Course/Weather Data")
#setwd("./Weather Data") #The . means the current wd (Shorter version)

#Read data 
Chicago <- read.csv("Chicago-F.csv", row.names=1) #row.names = 1 means that the name of the column will be the name of the 1st row, not 1, 2, 3, 4 etc 
Chicago 
NewYork <- read.csv("NewYork-F.csv", row.names=1)
Houston <- read.csv("Houston-F.csv", row.names=1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names=1)

NewYork
Houston
SanFrancisco


is.data.frame(Chicago) #True
# lets convert to matrices: 
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)
is.data.frame(Chicago) #False 
is.matrix(Chicago)

#Lets put all of these into a list 

Weather <- list(Chicago, NewYork, Houston, SanFrancisco)
Weather #Has 4 components now for each city 

#To add names
Weather <- list(Chicago=Chicago, NewYork=NewYork, Houston=Houston, SanFrancisco=SanFrancisco)
Weather
Weather[3]
Weather[[3]]
Weather$Houston #Same as [[]]


#The apply function;
#apply() 1 means rows and 2 means columns 
#tappy()
#by()
#eapply()
#lapply()
#sapply()
#vapply()
#replicate
#mapply
#rapply

#For the sake of this project we will focus on apply, lappy, & sapply 

?apply
Chicago
apply(Chicago, 1, mean)
#check: 
mean(Chicago["DaysWithPrecip",])
#analyze one city: 
apply(Chicago, 1, max)
#for practice 
apply(Chicago, 2, max) #Shows max for each month 
apply(Chicago, 2, min)

#Compare cities 
apply(Chicago, 1, mean)
apply(NewYork, 1, mean)
apply(Houston, 1, mean)
apply(SanFrancisco, 1, mean)

#----------------- Apply function using loops 

Chicago
#Find the mean of every row: 
#1. via loops 

outputloop <- NULL #preparing an empty vector 

for(i in 1:5){ #run cycle
 outputloop[i] <- mean(Chicago[i,])
}
outputloop

#add names to output 
names(outputloop) <- rownames(Chicago)
outputloop

#2. Via apply function (Easier and quicker version)
apply(Chicago, 1, mean)
apply(NewYork, 1, mean)


# --------------------------- Using lapply()

?lapply
Chicago
#Make rows into columns and columns into rows 
t(Chicago)

lapply(Weather, t) # What is happening; list(t(Weather$Chicago), t(Weather$NewYork), t(Weather$Houston, t(Weather$SanFrancisco))
mynewlistweather <- lapply(Weather, t)

#Example 2 
rbind(Chicago, NewRow=1:12)
lapply(Weather, rbind, NewRow=1:12) #the l in lapply stands for list 

#Example 3 
rowMeans(Chicago) #Identical to: apply(Chicago, 1, mean)
lapply(Weather, rowMeans)

# ---------------------------------- Combining lapply() with []

Weather
Weather$Chicago[1,1]
#Same as 
Weather[[1]][1,1] #Gives the first row and column in the Chicago table 

#for all 4 cities 
lapply(Weather, "[", 1, 1) #The "[" is [1,1] , applied to all cities in the list.
# "[" is a subscript operator 
# when using lappy with "[" it subsets elements of a list, l means list

lapply(Weather, "[", 1, ) #First row, all columns 

lapply(Weather, "[", ,3) #All columns for march 

lapply(Weather, "[", 2, 4)
Weather

# ---------------------------------- Adding your own functions 
lapply(Weather, rowMeans) #Gets the mean for every row 
lapply(Weather, function(x) x[1,]) #same as lapply(Weather, "[", 1, )
lapply(Weather, function(x) x[2,])
lapply(Weather, function(x) x[,11])
#you can use any arguments not just x 
lapply(Weather, function(y) y[3,11])

#Look at the difference between high and low temperatures 
lapply(Weather, function(y) y[1,]-y[2,]) #Add math computations - 
#How much does the weather flunctuate 
lapply(Weather, function(y) round((y[1,]-y[2,])/y[2,],2))

WeatherDifference <- lapply(Weather, function(y) {
  round((y[1,] - y[2,]) / y[2,], 2)
})
WeatherDifference

#This section will be improved ^ 


# ----------------------------------- Using sapply()

?sapply
# Avghigh_F for July; 
lapply(Weather, "[", 1, 7) #returns a list
sapply(Weather, "[", 1, 7) #returns a vector 

#AvgHigh_F for 4th quarter; 
lapply(Weather, "[", 1, 10:12) 
sapply(Weather, "[", 1, 10:12) #Gives a matrix form 

lapply(Weather, rowMeans)
sapply(Weather, rowMeans) #Much more neat 
round(sapply(Weather, rowMeans), 2) #Deliverable (this section is ready)

# ------- Now we need to improve this part 

lapply(Weather, function(y) round((y[1,]-y[2,])/y[2,],2))
sapply(Weather, function(y) round((y[1,]-y[2,])/y[2,],2)) #This is better with sapply 


# ---------------------------------------- Nesting Apply() Function 

Weather
lapply(Weather, rowMeans)
Chicago
#How to get rowmax? 
apply(Chicago, 1, max)
#Apply to the whole list 
sapply(Weather, apply, 1, max)
lapply(Weather, apply, 1, max) #prefered approach
lapply(Weather, function(x) apply(x, 1, max)) #Same as the above 

#Tidy up; 
sapply(Weather, apply, 1, max) #Deliverable #3 
sapply(Weather, apply, 1, min) #Deliverable #4 


# ------------------------------------------- which.max() and which.min() (Advanced) 

?which.max
Chicago[1,]
which.max(Chicago[1,])
names(which.max(Chicago[1,]))
# ^ use apply to iterate over rows of the matrix 
# and we will have lapply or sapply to iterate over components of a list 
apply(Chicago, 1, function(x) names(which.max(x))) #for all rows 
#then 
lapply(Weather, function(y) apply(y, 1, function(x)names(which.max(x))))
sapply(Weather, function(y) apply(y, 1, function(x)names(which.max(x))))

sapply(Weather, function(y) apply(y, 2, function(x)names(which.max(x)))) #just for experimentation 
# 1 = rows : 2 = columns 


#Alone task: explore ggplot 2 with the Weather Data 






























































