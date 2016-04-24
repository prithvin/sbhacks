// Request API access: http://www.yelp.com/developers/getting_started/api_access 
var Yelp = require('yelp');
var cities = require('cities');
 
function yelpAPI(searchPhrase, latitude, longitude, callback) {

  var yelp = new Yelp({
    consumer_key: 'sOz-vG7fKr9u_f0ZgZ68yQ',
    consumer_secret: '9UFfn5hmVEzGJ_XwvtRA-duzEfI',
    token: '-JCMJwN14USia5CwwCM3m8wQECFk68jP',
    token_secret: 'ayCSbG3h_PR01qDuJLUQxvaFhJc',
  });
   
  // See http://www.yelp.com/developers/documentation/v2/search_api 
  yelp.search({ term: searchPhrase,"location":cities.gps_lookup(latitude, longitude).city, "cll": "" + latitude + "," + longitude})
  .then(function (data) {
    var restaurants = [];
    var restaurant = {};
    console.log(data)
    data.businesses.forEach(function(business){
      restaurant['title'] = business.name;
      restaurant['imageURL'] = business.image_url;
      restaurant['category'] = business.categories;
    });

    callback(data);
  })
  .catch(function (err) {
    callback(null);
  });
  
}

yelpAPI("indian",34.4,-119.8, function (data) {
  console.log("OMG");
});

module.exports = yelpAPI;

/*
  {
    Image_URL: 
    Title: 
    CategoryString: Indian, Asian
    Distance: 0.5 Miles,
    Review_Image: 
    #_of_Reviews: 123 
  }
*/
// image
// title
// category in a CSSTRING
// distance
// review image
// # of reviews
