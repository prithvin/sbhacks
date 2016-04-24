// Request API access: http://www.yelp.com/developers/getting_started/api_access 
var Yelp = require('yelp');
var cities = require('cities');
var haversine = require('haversine');
var _ = require('lodash/core');
 
function yelpAPI(searchPhrase, latitude, longitude, callback) {

  var yelp = new Yelp({
    consumer_key: 'sOz-vG7fKr9u_f0ZgZ68yQ',
    consumer_secret: '9UFfn5hmVEzGJ_XwvtRA-duzEfI',
    token: '-JCMJwN14USia5CwwCM3m8wQECFk68jP',
    token_secret: 'ayCSbG3h_PR01qDuJLUQxvaFhJc',
  });
   
  // See http://www.yelp.com/developers/documentation/v2/search_api 
  yelp.search({ term: searchPhrase,"category" : "restaurant", "location":cities.gps_lookup(latitude, longitude).city, "cll": "" + latitude + "," + longitude})
  .then(function (data) {
    var restaurants = [];
    

    start = {
      latitude: latitude,
      longitude: longitude
    };


    data.businesses.forEach(function(business){
      var restaurant = {};
    
      //Use haversine to calculate business distance
      end = {
        latitude: business.location.coordinate.latitude,
        longitude: business.location.coordinate.longitude
      }

      var distance = haversine(start, end);
      var category = _.flatten(business.categories);

      restaurant['id'] = business.id;
      restaurant['title'] = business.name;
      restaurant['imageURL'] = business.image_url;
      restaurant['category'] = category.join(", ");
      restaurant['distance'] = distance.toFixed(2);
      restaurant["reviewImage"] = business.rating_img_url_large;
      restaurant["reviewCount"] = business.review_count;
      
      restaurants.push(restaurant);
    });


    callback(restaurants);
  })
  .catch(function (err) {
    console.log(err);
    callback(null);
  });
  
}



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

// yelpAPI("indian",34.41,-119.8, function (data) {
//   console.log("OMG");
//   console.log(data);
// });

