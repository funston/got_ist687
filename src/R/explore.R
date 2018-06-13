#import libraries
library(tidyverse)
library(tidyr)
library(ggplot2) 
library(gdata)
#install.packages("magrittr")
library(magrittr)
library(sqldf)
#impoort csv
setwd("~/Library/Mobile Documents/com~apple~CloudDocs/ist-687/project")
got_data <- read.csv("./data.csv", header = TRUE)
summary(got_data)
got_data <- got_data %>% unite(episode_id, "season", "episode", remove = FALSE)
#creating data frame with just ratings data
got_data_ratings <- select(got_data, -character)
got_data_ratings <- select(got_data_ratings, - screen.time)
#Removing duplicates from dataframe
got_data_ratings <- distinct(got_data_ratings)
season1 <- filter(got_data, got_data$season == "1")
##season1 <- filter(season1, season1$screen.time > "400")
#plot episode ratings curve
ggplot(data = got_data_ratings) + geom_smooth(aes(x=episode,y = overall_rating, color = season)) +
  labs(title = "Episode Ratings Curve",
       x = "All Episodes",
       y = "Over all Rating")
#scatter plot
ggplot(data = got_data_ratings) + geom_jitter(aes(x=episode,y = overall_rating, color = season)) +
  labs(title = "Episode Scatter Plot",
       x = "All Episodes",
       y = "Over all Rating")
#Peason correlation test
cor.test(got_data_ratings$overall_rating, got_data_ratings$episode, method = "pearson")
#bar graph of episodes by number votes and ratings
ggplot(data = got_data_ratings) + geom_col(aes(x=episode_id,y = total_votes, fill = overall_rating)) +
  labs(title = "Episodes by Number Votes and Ratings",
       x = "All Episodes",
       y = "Number of Votes") +
  theme(axis.text.x = element_text(angle = 90))
#Filter to create a data frame of data for Arya
Arya <- filter(got_data, got_data$character == "Arya Stark")
#Arya screentime by episode and rating
ggplot(data = Arya) + geom_col(aes(x = episode_id, y = screen.time, fill = overall_rating)) +
  labs(title = "Arya Stark's Screentime",
       x = "All Episodes",
       y = "Duration of Screentime") +
  theme(axis.text.x = element_text(angle = 90))

## ATTEMPT TO CALCULATE A "WEIGHT" or "SCORE for each character

characters <- sqldf("select distinct(character) from got_data")
# for each character create a new data frame with their "rating rank" ?
times <- sqldf("select sum(\"screen.time\") as screen_time from got_data group by character")
# use our mean screen time to filter out small parts
filter_time <- mean(times$screen_time)

# > range(got_data$overall_rating)
# [1] 8.1 9.9
# our overall rating can be 8.1 to 9.9 so no character should be able
# to score more than 9.9. 
get_character_score <- function(char){
  # get the sum/total of this character screen time
  sql <- sprintf("select sum(\"screen.time\") as total from got_data where character == '%s'", char)
  total_screen_time <- sqldf(sql)  # episodes
  #message("Total Screen Time ", total_screen_time)
  # if this screen time is greater than our filter time (adjust??)
  # we calculate a score, otherwise return 0
  if (total_screen_time > filter_time){
    # get ALL of the screen time and overall rating for this character
    sql <- sprintf("select \"screen.time\", overall_rating from got_data where character == '%s'", char)
    data <- sqldf(sql)
    score <- 0
    # for each row calculate the weighed average based on each episodes overall_rating
    # and the %percentage of time this character was on screen
    # our Score is the total SUM of the (% time MULTIPLIED BY the rating) per episode
    for (i in 1:nrow(data)){
      r <- data[i,]
      timePercent <- r$screen.time / total_screen_time$total
     score <- score + (timePercent * r$overall_rating)
   }
    return (score)
  } else {
    return (0)
  }
}

# create our scores data frame
score <- c()
for (i in 1:nrow(characters)){
  character <- characters[i,]
  s <- get_character_score(character)
  score <- append(score, s)
}

df <- data.frame(characters, score)
df <- df[df$score != 0,]
df <- df[order(df$character),]
ggplot(df, aes(x=character, y=score)) + 
  geom_point(stat="identity") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
  

