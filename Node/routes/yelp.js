// Request API access: http://www.yelp.com/developers/getting_started/api_access 
var Yelp = require('yelp');

function yelp (searchPhrase, latitude, longitude) {
 var yelp = new Yelp({
    consumer_key: 'sOz-vG7fKr9u_f0ZgZ68yQ',
    consumer_secret: '9UFfn5hmVEzGJ_XwvtRA-duzEfI',
    token: '-JCMJwN14USia5CwwCM3m8wQECFk68jP',
    token_secret: 'ayCSbG3h_PR01qDuJLUQxvaFhJc',
  });
   
  // See http://www.yelp.com/developers/documentation/v2/search_api 
  yelp.search({ term: , location: 'Montreal' })
  .then(function (data) {
    console.log(data);
  })
  .catch(function (err) {
    console.error(err);
  });
}

module.exports = yelp();
