var Session = require('../models/session');
var express = require('express');
var _ = require('lodash');
var router = express.Router();

//Helper functions
function generateError(res, str) {
    res.send({
        "Status": "ERROR",
        "Data": str
    })
}

function checkDoesExistReqRes(mainreqresbody, arroffields) {
  if (mainreqresbody == null) {
    return false;
  }
  for (var x = 0; x < arroffields.length; x++) {
    if (mainreqresbody[arroffields[x]] == null)
      return false;
  }
  return true;
}

function noErrorsIfDataNotSent (mainreqresbody, arroffields, res) {
  if (mainreqresbody == null) {
    generateError(res, "No data sent");
    return false;
  }
  else if (!checkDoesExistReqRes(mainreqresbody, arroffields)) {
    generateError(res, "Not all the required data has been sent");
    return false;
  }
  return true;
}


// API 1
// right swipe left swipe make restaurnt a like
router.post('/set', function (req, res) {
      console.log("HEY");
  if (req.body.Data == null) {
    generateError(res, "No data sent");
  }
  else if (!checkDoesExistReqRes(req.body.Data, ["Name", "PhoneNumber", "SessionId", "Cuisine"])) {
    generateError(res, "Not all the required data has been sent");
  }
  else {
    Session.findOne({SessionCode: req.body.Data.SessionId}, function (err, data) {
      if (err || data == null) {
        generateError(res, "Looks like this session token is not valid!");
      }
      else {
        var phoneNo = parseInt(req.body.Data.PhoneNumber)
        console.log("PH " + phoneNo.toString());

        // if phone number does not exist, remove user, but do it nicely
        if(!phoneNo)
          generateError(res, "We're sorry. The restaurant you #swiped is unavailable. Please leave a voicemail.");
        
        //if everything passes
        console.log("D for " + data)
        var restaurantId = req.body.Data.RestaurantId;
        
        //Find restaurant voted on
        var restaurant = _.filter(data.Restaurants, [restaurantId, this.YelpID]);
        console.log(restaurant)

        //Create update object
        var updateObj = {}
        var yelpID = restaurant.YelpID;

        Session.update({"Restaurants": "Votes"}, {$set :{"Votes": phoneNo.toString()}}, function (err, up) {
          if (err) 
            generateError(res, err);
          else
            res.send({"Status" : "SUCCESS", "Data" : "Yay! You've been added to this session!"});
        });
      }
    });
  }
});

// API 2
// return 5 top restaurants based on likes

module.exports = router;