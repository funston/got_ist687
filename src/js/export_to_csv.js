var fs = require('fs');

function get_seconds_duration(start, end){
  var a = start.split(':'); // split it at the colons  
  var x = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]);
  var b = end.split(':'); // split it at the colons
  var y = (+b[0]) * 60 * 60 + (+b[1]) * 60 + (+b[2]);
  return y - x;
}

var data = fs.readFileSync(process.argv[2], 'utf8');
data = JSON.parse(data);


var hdr = "season,episode,overall_rating,total_votes,";
for (var i = 1; i < 11; i++){
  hdr += "rating_reviews_"+i+","+"rating_percentage_"+i+",";
}

var demographic = ["All", "Male", "Female"];
var ages = ["All", "18", "18-29", "30-44", "45+"];

demographic.forEach(function(d){
  ages.forEach(function(a){
    hdr += "gender_"+d+"_age_"+a+"_rating,"+"gender_"+d+"_age_"+a+"_reviews,";
  });
});
hdr += "character,screen time";
console.log(hdr);



data.forEach(function(season){
  var season_num = season.season;
  season.episodes.forEach(function(episode){
    var episode_num = episode.episode;
    var rating = episode.rating;
    var reviews = episode.votes;

    var row = season_num+","+episode_num+","+rating+","+reviews+",";
    var user_ratings = episode.ratings.users;
    user_ratings.forEach(function(r){
      row += r.reviews + "," + r.percentage+",";
    });
    var user_demographic = episode.ratings.demographic;
    var info = {}; 
    user_demographic.forEach(function(d){
      info[d.gender+":"+d.age] = d;
    });
    demographic.forEach(function(d){
      ages.forEach(function(a){
        row += info[d+":"+a].rating +","+info[d+":"+a].reviews+",";
      });
    });
    var characters = episode.characters;
    characters.forEach(function(c){
      // for each "row", add each character and screen time
      var r = row+","+c.name+","+c.duration;
      console.log(r);
    });
  });
});
