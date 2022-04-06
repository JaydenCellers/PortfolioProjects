# Installation of necessary packages for displaying graphs
install.packages("digest")
install.packages("reshape2")
install.packages("devtools")
devtools::install_github("hrbrmstr/ggalt")
install.packages("dplyr")
install.packages("purrr")
library("dplyr")
library(ggalt)
library("reshape2")
library("UsingR")
library(ggplot2)

# Loading in the data set file
hour <- read.csv("hour.csv")
hour <- as.data.frame(hour)

# Data Cleaning
# Clean up names
names(hour) <- c("instant", "date", "season", "year", "month", "hour", "holiday",
                 "day", "workday", "weather", "temperature", "feels_like", 
                 "humidity", "windspeed", "casual_users", "registered_users", 
                 "total_users")
# Name the seasons
index_spring <- which(hour$season == 2)
index_summer <- which(hour$season == 3)
index_fall <- which(hour$season == 4)
index_winter <- which(hour$season == 1)
hour$season[index_spring] <- "Spring"
hour$season[index_summer] <- "Summer"
hour$season[index_fall] <- "Fall"
hour$season[index_winter] <- "Winter"


# List the actual years
index_2011 <- which(hour$year == 0)
index_2012 <- which(hour$year == 1)
hour$year[index_2011] <- 2011
hour$year[index_2012] <- 2012

# List the actual Months
hour$month <- factor(hour$month, 
                     ordered = TRUE,
                     levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
                     labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
# Holiday or not
hour$holiday <- as.logical(hour$holiday)

# Days of the week
hour$day <- factor(hour$day,
                   ordered = TRUE,
                   levels = c(0, 1, 2, 3, 4, 5, 6),
                   labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))

# Workday or not
hour$workday <- as.logical(hour$workday)

# Weather codes
hour$weather[which(hour$weather == 1)] <- "Clear - Partly cloudy"
hour$weather[which(hour$weather == 2)] <- "Cloudy mist"
hour$weather[which(hour$weather == 3)] <- "Light Precipitation - Thunderstorm"
hour$weather[which(hour$weather == 4)] <- "Heavy Precipitation - Foggy snow"

# Converting Temp from relative C to actual F rounding to one decimal point
hour$temperature <- round(1.8 * (hour$temperature * 47 - 8) + 32, 1)
hour$feels_like <- round(1.8 * (hour$feels_like * 66 - 16) + 32, 1)

# Turning humidity into percent
hour$humidity <- hour$humidity * 100

# Converting normalized wind speed to mph rounding to one decimal point
hour$windspeed <- round(hour$windspeed * 67 / 1.609, 1)

# Graphs-------------------------------------------------------------------------------------------------------------------

## Dumbbell Plot
# Creating new data frames, one for each year and exclusion of leap day
hour_new <- filter(hour, year == "2011")
hour_new2 <- filter(hour, year == "2012")
hour_new2 <- filter(hour_new2, date != "2012-02-29")
hour_new2$instant <- c(1:8711)

hour_new$total_users_2011 <- hour_new$total_users
hour_new2$total_users_2012 <- hour_new2$total_users

# Joining the data for the use of a dumbbell plot
hour_dumbbell <- inner_join(hour_new, hour_new2, by = "instant")

# Identifying the indexes for each month in the data
jan_index <- which(hour_dumbbell$month.x == "Jan")
feb_index <- which(hour_dumbbell$month.x == "Feb")
mar_index <- which(hour_dumbbell$month.x == "Mar")
apr_index <- which(hour_dumbbell$month.x == "Apr")
may_index <- which(hour_dumbbell$month.x == "May")
jun_index <- which(hour_dumbbell$month.x == "Jun")
jul_index <- which(hour_dumbbell$month.x == "Jul")
aug_index <- which(hour_dumbbell$month.x == "Aug")
sep_index <- which(hour_dumbbell$month.x == "Sep")
oct_index <- which(hour_dumbbell$month.x == "Oct")
nov_index <- which(hour_dumbbell$month.x == "Nov")
dec_index <- which(hour_dumbbell$month.x == "Dec")


# Averaging the total amount of users per month for both years
jan2011_avg <- mean(hour_dumbbell$total_users_2011[jan_index])
jan2012_avg <- mean(hour_dumbbell$total_users_2012[jan_index])
feb2011_avg <- mean(hour_dumbbell$total_users_2011[feb_index])
feb2012_avg <- mean(hour_dumbbell$total_users_2012[feb_index])
mar2011_avg <- mean(hour_dumbbell$total_users_2011[mar_index])
mar2012_avg <- mean(hour_dumbbell$total_users_2012[mar_index])
apr2011_avg <- mean(hour_dumbbell$total_users_2011[apr_index])
apr2012_avg <- mean(hour_dumbbell$total_users_2012[apr_index])
may2011_avg <- mean(hour_dumbbell$total_users_2011[may_index])
may2012_avg <- mean(hour_dumbbell$total_users_2012[may_index])
jun2011_avg <- mean(hour_dumbbell$total_users_2011[jun_index])
jun2012_avg <- mean(hour_dumbbell$total_users_2012[jun_index])
jul2011_avg <- mean(hour_dumbbell$total_users_2011[jul_index])
jul2012_avg <- mean(hour_dumbbell$total_users_2012[jul_index])
aug2011_avg <- mean(hour_dumbbell$total_users_2011[aug_index])
aug2012_avg <- mean(hour_dumbbell$total_users_2012[aug_index])
sep2011_avg <- mean(hour_dumbbell$total_users_2011[sep_index])
sep2012_avg <- mean(hour_dumbbell$total_users_2012[sep_index])
oct2011_avg <- mean(hour_dumbbell$total_users_2011[oct_index])
oct2012_avg <- mean(hour_dumbbell$total_users_2012[oct_index])
nov2011_avg <- mean(hour_dumbbell$total_users_2011[nov_index])
nov2012_avg <- mean(hour_dumbbell$total_users_2012[nov_index])
dec2011_avg <- mean(hour_dumbbell$total_users_2011[dec_index])
dec2012_avg <- mean(hour_dumbbell$total_users_2012[dec_index])

# Turning those averages into vectors
avg_2011 <- c(jan2011_avg, feb2011_avg, mar2011_avg, apr2011_avg, may2011_avg, 
              jun2011_avg, jul2011_avg, aug2011_avg, sep2011_avg, oct2011_avg, 
              nov2011_avg, dec2011_avg)
avg_2012 <- c(jan2012_avg, feb2012_avg, mar2012_avg, apr2012_avg, may2012_avg, 
              jun2012_avg, jul2012_avg, aug2012_avg, sep2012_avg, oct2012_avg, 
              nov2012_avg, dec2012_avg)

# Creating labels for the months
z <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
z <- factor(z, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

# Creating a data frame from the labels and the averages for the two years
df <- data.frame(z, avg_2011, avg_2012)

# Plotting the data on a dumbbell plot
ggplot(df, mapping = aes(x = avg_2011, xend = avg_2012, y = rev(z))) + 
  geom_dumbbell(size = 1.5,
                size_x = 5, 
                size_xend = 5,
                colour = "grey", 
                colour_x = "tan1", 
                colour_xend = "yellowgreen") +
  theme_minimal() + 
  theme(axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid")) +
  scale_y_discrete(labels = rev(z)) +
  labs(title = "Dumbbell Chart",
       subtitle = "Change in Average No. of Users from 2011 to 2012",
       x = "Avg. Number of Total Users",
       y = "Month") 

## Calendar Heat Map
# Creating a new categorical variable "time of day" breaking down the 24 hour
# day to 4 larger time periods of 6 hours each.
hour$time_of_day <- hour$hour
index_early_am <- which(hour$time_of_day <= 5)
index_am <- which(hour$time_of_day > 5 & hour$time_of_day <= 11)
index_pm <- which(hour$time_of_day > 11 & hour$time_of_day <= 17)
index_late_pm <- which(hour$time_of_day > 17 & hour$time_of_day <= 23)
hour$time_of_day[index_early_am] <- "Early"
hour$time_of_day[index_am] <- "AM"
hour$time_of_day[index_pm] <- "PM"
hour$time_of_day[index_late_pm] <- "Late"
hour$time_of_day <- factor(hour$time_of_day, ordered = TRUE, 
                           levels = c("Early", "AM", "PM", "Late"))


#The creation of the heat map with the previous alteration in the data
ggplot(hour, mapping = aes(x = time_of_day, y = day, fill = total_users)) + 
  geom_tile(colour = "white") + 
  facet_grid(year ~ season) + 
  scale_fill_gradient(low = "palegreen", high = "sienna1") +
  theme_minimal() +
  labs(x = "Time of Day",
       y = "Day of the Week",
       title = "Time-Series Calendar Heatmap", 
       subtitle = "Total Users", 
       fill = "Number of Users")

## Population Pyramid
# Creating the population pyramid by manipulation of the bar plot
ggplot(data = hour) +
  geom_bar(mapping = aes(x = day, y = -casual_users, fill = "Casual Users"), 
           stat = "identity") +
  geom_bar(mapping = aes(x = day, y = registered_users, 
                         fill = "Registered Users"), stat = "identity") +
  coord_flip() +
  labs(title = "Population Pyramid",
       subtitle = "Number of Casual vs Registered Users by Day of the Week", 
       fill = "Type of User") +
  xlab("Day of the Week") +
  theme(legend.title = element_blank()) +
  theme_minimal() + 
  theme(axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid")) +
  scale_fill_brewer(palette = "Accent") +
  ylab("Number of Users") +
  scale_y_continuous(breaks = seq(-150000,400000,100000), 
                     labels = paste0(as.character(c(150, 50, 50, 150, 250, 350)), "k"))


## Boxplot
# Creation of the boxplot
ggplot(data = subset(hour, weather != "Heavy Precipitaion - Foggy snow")) +
  geom_boxplot(mapping = aes(y = casual_users, x = as.factor(weather), 
                             fill = as.factor(time_of_day))) +
  labs(fill = "Time of Day", x = "Weather Conditions", 
       y = "Number of Casual Users", 
       subtitle = "Relationship between Casual Bike Users and Weather During Different Times of the Day",
       title = "Box Plot") +
  theme_minimal() + scale_fill_brewer(palette = "Accent") +
  theme(axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"))
