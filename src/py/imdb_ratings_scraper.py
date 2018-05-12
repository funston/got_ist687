# -*- coding: utf-8 -*-
# export PYTHONIOENCODING=utf-8
# pip install beautifulsoup4
# get demographics
from bs4 import BeautifulSoup
from urllib.request import urlopen


def get_breakdown(url):
    id = url.split("/")[2]
    breakdown_url = "https://www.imdb.com/title/%s/ratings?ref_=tt_ov_rt" % id
    response = urlopen(breakdown_url, timeout = 5)
    content = response.read()
    soup = BeautifulSoup(content, 'html.parser')
    tables = soup.findAll("table")
    table = tables[0]
    # table iterates 10 rows of ratings
    rows = table.findAll("tr")
    rate = 10
    rows = rows[1:]
    ratings = []
    
    for row in rows:
        cols = row.findAll("td")
        if (cols):
            rating = cols[1].find("div", {"class":"topAligned"})
            rp = rating.get_text().strip()
            reviews = cols[2].find("div", {"class":"leftAligned"})
            r = reviews.get_text().strip()
            #print("Rating %d Percent %s Reviews %s" % (rate, rp, r))
            data = {
                'rating':rate,
                'percentage':float(rp.replace("%", "")),
                'reviews':int(r.replace(",",""))
            }
            ratings.append(data)
        rate -= 1
        if (rate < 1):
            break

    dtable = tables[1]
    rows = dtable.findAll("tr")
    # breakdown: All, 18, 18-29, 30-44, 45+
    names = ["All", "Male", "Female"]
    colnames = ["All", "18", "18-29", "30-44", "45+"]
    
    rows = rows[1:]
    # first row is ALL, then Male, then Female
    results = {
        'users':ratings,
        'demographic':[]
    }
    
    irow = 0
    for row in rows:
        icol = 0        
        cols = row.findAll("td")
        cols = cols[1:]
        for colname in colnames:
            allR = cols[icol].find("div", {"class":"bigcell"})
            allN = cols[icol].find("a")
            #print(allR)
            #print(allN)
            data = {
                'gender':names[irow],
                'age':colnames[icol],
                'rating':float(allR.get_text().strip()),
                'reviews':int(allN.get_text().strip().replace(",",""))
            }
            results['demographic'].append(data)
            #print(data)
            icol += 1
        irow += 1
    ###print(results)
    return results
    
def get_ratings(url, seasons):
    results = []
    for i in range(1,seasons):
        season = {
            "season":i,
            "episodes":[]
        }
        response = urlopen(url+str(i), timeout = 5)
        content = response.read()
        soup = BeautifulSoup(content, 'html.parser')
        episodes = soup.findAll("div", {"class": "info"})
        print("\nSeason %d Episodes %d" % (i, len(episodes)))
        
        for episode in episodes:
            meta = episode.find("meta")
            e = episode.find("a")
            title = e.get("title").encode('utf-8')
            href = e.get("href")
            airdate = episode.find("div", {"class":"airdate"})
            rating = episode.find("span", {"class":"ipl-rating-star__rating"})
            votes = episode.find("span", {"class":"ipl-rating-star__total-votes"})
            # https://www.imdb.com/title/tt5654088/ratings?ref_=tt_ov_rt
            # episode create url breakdown
            breakdown = get_breakdown(href)
            if votes is not None:
                v = votes.get_text().strip()
                l = len(v) - 1
                v = v[1:l]
                data = {
                    "season":i,
                    "episode":int(meta.get("content")),
                    "title":str(title.decode('utf-8')).replace("'", ""),
                    "date":airdate.get_text().strip(),
                    "rating":rating.get_text().strip(),
                    "votes":v,
                    "ratings":breakdown
                }
                season["episodes"].append(data)
        results.append(season)

    return results

        #print(str(meta.content) + " " + str(airdate) + " " + rating + " " + votes);



## Westworld: https://www.imdb.com/title/tt0475784/ratings?ref_=tt_ov_rt


## Westworld
#westworld = "https://www.imdb.com/title/tt0475784/episodes?season="
#seasons = 2
#print("Westworld")
#get_ratings(westworld, seasons)

# get summaries from here
# https://www.imdb.com/title/tt0475784/ratings?ref_=tt_ov_rt

got = "https://www.imdb.com/title/tt0944947/episodes?season="
seasons = 8
data = get_ratings(got, seasons)
import json
with open('ratings.json', 'w') as outfile:
    json.dump(data, outfile)

# summary: https://www.imdb.com/title/tt0944947/ratings?ref_=tt_ov_rt
# rating breakdown per show
#w_url = "https://www.imdb.com/title/tt5655178/ratings?ref_=tt_ov_rt"
#get_breakdown(w_url)

#turl = "/title/tt4227538/?ref_=ttep_ep1"
#get_breakdown(turl)
