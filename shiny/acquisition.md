#### The Data 

##### IMBD Ratings

IMDB presented web pages with ratings information about each episode broken down by overall and demographic.

The first step was to write a scraper to grab this data using a python script.

<a href="https://github.com/rschiavi/got_ist687/blob/master/src/py/imdb_ratings_scraper.py" target="_blank">imdb_ratings_scraper.py</a>

The next step was to merge the rating and episode data

<a target="_blank" href="https://github.com/rschiavi/got_ist687/blob/master/src/js/merge_ratings_got_episode_data.js">merge_ratings.js</a>

##### Game of Thrones Screen Times

A few articles mentioned fans of the show who had documented all the screen times for each character. Finding this was a challenge but eventually we found it here

<a href="https://raw.githubusercontent.com/shubhstiws/got_screentime/master/episodes.json" target="_blank">Game of Thrones Raw Data</a>

##### Combining the Data

The last step was to join the data into a useful CSV format to start to analyze. We used the tidyformat to create rows for every character using this code:

<a href="https://github.com/rschiavi/got_ist687/blob/master/src/js/export_to_csv.js" target="_blank">Export to CSV</a>

Finally, our CSV format to import into R
<br>
<a target="_blank" href="https://github.com/rschiavi/got_ist687/blob/master/data/data.csv">Data Format</a>


