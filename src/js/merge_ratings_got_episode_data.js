var fs = require('fs');
var moment = require('moment');

function get_seconds_duration(start, end){
  var a = start.split(':'); // split it at the colons  
  var x = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]);
  var b = end.split(':'); // split it at the colons
  var y = (+b[0]) * 60 * 60 + (+b[1]) * 60 + (+b[2]);
  return y - x;
}

var data = fs.readFileSync(process.argv[2], 'utf8');
data = JSON.parse(data);

var ratings = fs.readFileSync(process.argv[3], 'utf8');
ratings = JSON.parse(ratings);

var seasons = {};
var characters = {};
var locations = {};
var episodes = {}


data.episodes.forEach(function(episode){
  if (!seasons[episode.seasonNum]){
    seasons[episode.seasonNum] = [];
  }
  seasons[episode.seasonNum].push(episode);
});

//console.log("Seasons ", Object.keys(seasons));

Object.keys(seasons).forEach(function(s){
  var data = seasons[s];
  data.forEach(function(episode){
    var episodeNum = episode.episodeNum;
    if (!episodes[s]){
      episodes[s] = {
        season:s,
        episodes:{}
      }
    }
    if (!episodes[s][episodeNum]){
      episodes[s][episodeNum] = {
        characters:{},
        number:episodeNum,
        title:episode.episodeTitle,
        locations:{}
      };
    }

    episode.scenes.forEach(function(scene){
      var start = scene.sceneStart;
      var end = scene.sceneEnd;
      var duration = get_seconds_duration(start, end);
      
      scene.characters.forEach(function(c){
        c = c.name;
        c = c.replace(/'/g, "")
        
        if (!characters[c]){
          characters[c] = {};
        }
        if (!characters[c][episodeNum]){
          characters[c][episodeNum] = 0;
        }
        characters[c][episodeNum] = characters[c][episodeNum] + duration;
        episodes[s][episodeNum].characters[c] = characters[c][episodeNum];
      });

      var l = scene.location;
      if (!locations[l]){
        locations[l] = {};
      }
      if (!locations[l][episodeNum]){
        locations[l][episodeNum] = 0;
      }
      locations[l][episodeNum] = locations[l][episodeNum] + duration;
      episodes[s][episodeNum].locations[l] = locations[l][episodeNum];
    });
  });
})

/*console.log(Object.keys(episodes));
var season_one = episodes['1'];
Object.keys(season_one).forEach(function(episode){
  var e = season_one[episode];
  if (e){
    console.log(e.title);
  } else {
    console.log("No episode ", episode);
  }
});*/

ratings.forEach(function(rating){
  var season = rating.season;
  var data = episodes[season];
  rating.episodes.forEach(function(r){
    var num = r.episode;
    var d = episodes[season][num];
    var characters = [];
    var locations = [];
    Object.keys(d.characters).forEach(function(c){
      var x = {name:c, duration:d.characters[c]}
      characters.push(x);
    });
    Object.keys(d.locations).forEach(function(c){
      var x = {name:c, duration:d.locations[c]};
      locations.push(x);
    });
    
    r.characters = characters;
    r.locations = locations;
  });
  
  /*data.episodes.forEach(function(episode){
    var r = rating.episodes[episode.episodeNum];
    rating.episodes.rating = r;
  });*/
});

console.log(JSON.stringify(ratings));


//console.log(characters);
//console.log(locations);
