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

We initially exploring building a way to rank each character, giving them
a weight. Our intuition was that we could or would need to use such a weighting
for our prediction algorithm. The results were remarkably accurate building
a weight for the "most popular" characters using just the screen time data
and IMBD ratings. The code above produces the following

<img src="analysis/image014.png"/>


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