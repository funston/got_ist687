#install.packages("ggplot2")
#
# This is really just a R experiment to take the Combined GoT ScreenTime and User Ratings/Demographics
# and mine the data. The next step would be to build whatever data structure is needed to look for
# any correlation between Character/Location Screen Time, and User Ratings By Demographic. Finally,
# we would take this prediction algorithm and run it against the training data against an episode and
# see how close our predictions by Demographic come to the real reviews.

library(ggplot2)
library(jsonlite)


barChart <- function(data){
  ggplot(data=data, aes(x=name, y=duration)) + geom_bar(colour="black", stat="identity", width=0.5)
}

processScreenTime <- function(type, data){
    message("\tScreen Time: ", type)
    data <- data[order(-data$duration),]
    for (i in 1:nrow(data)){
      c <- data[i,]
      message("\t\t Name: ", c$name, " ", c$duration, "(s)" )
    } 
}

processEpisode <- function(episode){
  message(episode$title)
  characters <- episode$characters #[row]
  characters <- do.call("rbind", characters)
  characters <- characters[which(characters$duration > 60),]
  processScreenTime("Characters", characters)
 
  locations <- episode$locations #[row]
  locations <- do.call("rbind", locations)
  locations <- locations[which(locations$duration > 60), ]
  processScreenTime("Location", locations)
  processRatings(episode)
}


processRatings <- function(episode){
  rating <- episode$rating
  votes <- episode$votes
  message("\tRating ", rating, " Votes ", votes)
  ratings <- episode$ratings
  user_ratings <- do.call("rbind", ratings$users[1])
  #print(user_ratings)
  for (row in 1:nrow(user_ratings)){
    message("\t\t Rating ", user_ratings[row,]$rating, " ", user_ratings[row,]$percentage, "% Votes ", user_ratings[row,]$reviews)
  }
  user_demographics <- do.call("rbind", ratings$demographic[1])
  for (row in 1:nrow(user_demographics)){
    message("\t\t Gender:", user_demographics[row,]$gender, " Age: ", 
            user_demographics[row,]$age, " Rating ", user_demographics[row,]$rating, " Votes ",
            user_demographics[row,]$reviews)
  }
}

processSeason <- function(episodes){
  for (row in 1:nrow(episodes)){
    episode <- episodes[row,]
    processEpisode(episode)
  }
}

data <- file.choose()
lines <- readLines(data)
#json_data = fromJSON(lines, flatten=TRUE)

json_data = fromJSON(lines)
for (row in 1:nrow(json_data)){
  season <- json_data[row,]
  message("Season ", season$season)
  episodes <- do.call("rbind", season$episodes)
  processSeason(episodes)
  print("************")
}
