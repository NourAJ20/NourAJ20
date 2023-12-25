#2nd part 

#Lists in R 

#Deliverable - a list with the following components; 
#Character: Machine Name 
#Vector: (min,mean,max) Utilization for the month (Excluding unknown hours)
#Logical: Has utilization ever fallen below 90%? True/false 
#Vector: All hours where utilization in unknown (NA's)
#DataFrame: for this machine 
#Plot: for all machines 

getwd()

util <- read.csv("P3-Machine-Utilization.csv")
head(util)
str(util)
summary(util)

#Derive utilization column (make a new column)
util$Utilization = 1 - util$Percent.Idle
head(util,12)

# --------- Handling data-time in R 
?POSIXct #represents calander dates and times
#convert timestamp data into POSIXct 
as.POSIXct(util$Timestamp, format = "%d/%m/%Y %H:%M")
#put inside data frame 

util$PosixTime <- as.POSIXct(util$Timestamp, format = "%d/%m/%Y %H:%M")

head(util, 12)

# --- TIP: how to rearrange columns in a dataframe 
util$Timestamp <- NULL #Removes the column 

util <- util[,c(4, 1, 2, 3)]  #4 = PositTime, 1 = Machine etc 
head(util, 12)

#What is a list
summary(util)

RL1 <- util[util$Machine == "RL1",]
summary(RL1)
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

#Construct List: 
#Character: Machine Name 
#Vector: (min,mean,max) Utilization for the month (Excluding unknown hours)
#Logical: Has utilization ever fallen below 90%? True/false 


util_stats_rl1 <- c(min(RL1$Utilization, na.rm = T), 
                   mean(RL1$Utilization, na.rm = T),
                   max(RL1$Utilization, na.rm = T))

which(RL1$Utilization < 0.90)

util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0 
#list 
list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)

#Naming components of a list 
list_rl1
names(list_rl1) #Comes back as NULL indicating there are no names
names(list_rl1) <- c("Machine", "Stats", "LowThreshold")
list_rl1

#Another method 
#list_rl1 <- list(Machine = "Rl1", Stats=util_stats_r1l, LowThreshold=util_under_90_flag)

# ------------ Extracting components of a list 
#Three ways; 
# [] - will always return a list 
# [[]] - will always return the actual object 
# $ - same as [[]] but prettier 

list_rl1
list_rl1[1]
list_rl1[[1]]
list_rl1$Machine

list_rl1[2]
typeof(list_rl1[2])
list_rl1[[2]]
list_rl1$Stats
typeof(list_rl1$Stats)

#Access third component in the Stats list 
list_rl1[[2]][3]
list_rl1$Stats[3]

list_rl1
list_rl1[3]
list_rl1[[3]]
list_rl1$LowThreshold
typeof(list_rl1$LowThreshold) #Logical means binary or boolean values, True, False 


# -------------- Adding and Deleting components 
list_rl1
list_rl1[4] <- "New Information"
list_rl1

#Another way 
RL1[is.na(RL1$Utilization), "PosixTime"]
list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization), "PosixTime"]
list_rl1

#How to remove a component; Use the Null method:
#list_rl1[4] <- NULL 

#Add another component 
#Data frame: for this machine 
list_rl1$Data <- RL1
summary(list_rl1)

#list_rl1$UnknownHours[1]

# ------ Subsetting a list 
list_rl1$Machine[1]
list_rl1[c(1:4)]

sublist_rl1 <- list_rl1[c("Machine", "Stats")]
sublist_rl1
#This creates a new list (for easy access)

# only () are for subsetting, not []

# --------------------------------------- Visualization 
#timeseries plot 
library(ggplot2)
p <- ggplot(data=util)
p + geom_line(aes(x=PosixTime, y = Utilization, 
                  colour = Machine), size = 1.2) + 
  facet_grid(Machine~.) + 
  geom_hline(yintercept = 0.90, 
             colour = "Gray", size=1.2, 
             linetype = 3)

util_plot <- p + geom_line(aes(x=PosixTime, y = Utilization, 
                               colour = Machine), size = 1.2) + 
  facet_grid(Machine~.) + 
  geom_hline(yintercept = 0.90, 
             colour = "Gray", size=1.2, 
             linetype = 3)

#Add plot to list 
list_rl1$Plot <- util_plot
list_rl1 #appears in the grid area 

summary(list_rl1) #plot is there 











