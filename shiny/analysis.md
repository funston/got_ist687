### Initial Data Analysis

#### Exploration 

We first explored the data to see if we could identify any trends.

The following R code builds the following helpful visualizations.

<a target="_blank" href="https://github.com/rschiavi/got_ist687/blob/master/src/R/visuals_GOT_5_18_18.R">Visuals.R</a>


<img src="analysis/image002.png"/>
<img src="analysis/image004.png"/>
<img src="analysis/image006.png"/>
<img src="analysis/image008.png"/>
<img src="analysis/image010.png"/>
<img src="analysis/image012.png"/>


#### Assign Weighting to Each Character



We initially exploring building a way to rank each character. The idea was to
give each character a weight/score using their screen time data and ratings.


Our intuition was that we could or would need to use such a weighting
for our prediction algorithm.

The results were remarkably accurate assigning a weight for the "most popular"
characters using just the screen time data and IMBD ratings.

<img src="analysis/image014.png"/>


### Code:
```
 got_data$character <- as.character(got_data$character)
got_data$episode_id <- as.character(got_data$episode_id)
cummulative_screentime$character <- as.character(cummulative_screentime$character)

got_data_2 <- left_join(got_data, cummulative_screentime, by = "character")
got_data_2 <- got_data_2 %>%
  mutate(rating_st = got_data_2$overall_rating * got_data_2$screen.time* got_data_2$sum)

got_data_2 <- got_data_2 %>%
  group_by(episode_id) %>%
  mutate(rating_norme = my_norm(rating_st))

got_data_2 <- got_data_2 %>%
  mutate(weighted_rating = rating_norme*10)

mean_rating_weighted <- got_data_2 %>%
  group_by(character) %>%
  summarise(avr = mean(weighted_rating))

mean_rating_weighted <- left_join(cummulative_screentime, mean_rating_weighted, by = "character")
top_characters <- filter(mean_rating_weighted, mean_rating_weighted$avr > "0.23")
1.	Calculated cumulative screen time 
2.	Then multiplied Overall rating, Screen time, and Cumulative character screen time together for each character and each episode
To create new variable called “rating_st” (short for rating and screen time)
3.	Normalized the new variable by each episode to create another variable called “norme” short for normalized episode rating. 
4.	Then  rescaled the value of norme to be on a scale of 1 to 10.
5.	For the visualization, calculated the mean for the weighted rating grouped by characters.
6.	Lastly, took the 35 characters with highest mean rating
7.	While in theory good at predicting popular character, This variable worked poorly in our prediction models, which we will discuss in detail later. 
```



### Attempt 2

The following code was another attempt to "weight" each character


```
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
```
