var Session = require('../models/session');
var express = require('express');
var router = express.Router();
// var yelp = require('../yelp-api');

function generateSessionToken(callback) {
    var code = Math.floor(100000 + Math.random() * 900000);
    Session.findOne({sessionCode: code}, function (err, data) {
        if (data != null) {
            generateSessionToken(callback);
        }
        else {
            callback(code);
        }
    });
}

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

// User wants to join session
router.post('/joinSession', function (req, res) {
  if (req.body.Data == null) {
    generateError(res, "No data sent");
    console.log("SAY");
  }
  else if (!checkDoesExistReqRes(req.body.Data, ["Name", "PhoneNumber", "SessionId", "Cuisine"])) {
    generateError(res, "Not all the required data has been sent");
    console.log("BAE");
  }
  else {
    Session.findOne({SessionCode: req.body.Data.SessionId}, function (err, data) {
      console.log("HEY");
      if (err || data == null) {
        generateError(res, "Looks like this session token is not valid!");
      }
      else {
        var phoneNo = parseInt(req.body.Data.PhoneNumber)
        for (var x = 0; x < data.Users.length; x++) {
          if (data.Users[x].PhoneNumber == phoneNo) {
            res.json({"Status": "SUCCESS","Data": "You are already in this session so you're good!" });
            return;
          }
        }

        // if phone number does not exist, user must be added
        var user = {
          Name: req.body.Data.Name,
          PhoneNumber: phoneNo,
          Cuisines: req.body.Data.Cuisine,
          Location: {
            Latitude: 0,
            Longitude: 0
          }
        };
        Session.update({SessionCode: req.body.Data.SessionId}, {$push : {"Users": user}}, function (err, up) {
          if (err) 
            generateError(res, err);
          else
            res.send({"Status" : "SUCCESS", "Data" : "Yay! You've been added to this session!"});
        });
      }
    });
  }
});


//Route 2 - Create new session
router.post("/create", function (req, res) {
    generateSessionToken(function (code) {
        if (req.body.Data == null) {
            generateError(res, "No data sent");
        }
        else if (!req.body.Data.PhoneNumber || !req.body.Data.Name || !req.body.Data.Cuisine) {
            generateError(res, "Not all the required data has been sent");
        }
        else {
            var number = parseInt(req.body.Data.PhoneNumber);
            var name = req.body.Data.Name;
            var cuisines = req.body.Data.Cuisine;
            var newSession = new Session({  //LATER - Trim schema
              "SessionCode": code,
              "Restaurants": [
              ],
              "Users": [
                {
                  Name: name,
                  PhoneNumber: number,
                  Cuisines: [cuisines],
                  Location: {
                    Latitude: 0,
                    Longitude: 0
                  }  
                }
              ],
            });

            newSession.save(function (err) {
              if (err)
                generateError(res, "Unable to create new session");
            });

            res.json({"Status": "SUCCESS","Data": code + "" });
        }
    });


});

router.post('/saveLatLong', function (req, res) {
  if (noErrorsIfDataNotSent(req.body.Data, ["Latitude", "Longitude", "SessionId", "PhoneNumber"], res)) {

    // this means everything is valid and reday to gooo!!
    Session.findOne({SessionCode : req.body.Data.SessionId}, function (err, data) {
      if (err || data == null) {
        generateError(res, "Looks like this session token is not valid!");
      }
      else {
        var phoneNo = parseInt(req.body.Data.PhoneNumber);
        // check to see if user is in the session!
        var userLegitInSession = -1;
        console.log(phoneNo);
        for (var x = 0; x < data.Users.length; x++) {
          if (data.Users[x].PhoneNumber == phoneNo) {
            userLegitInSession = x; // saves the index
            break;
            // great, user is actually legit
          }
        }

        if (userLegitInSession == -1) {
          generateError(res, "Um..Looks like you're not in this group!");
          return;
        }

        // now, it is for users in the legit, who are being added
        var copyData = JSON.parse(JSON.stringify(data.Users[userLegitInSession].Location));
        copyData = {
          Latitude: req.body.Data.Latitude,
          Longitude: req.body.Data.Longitude
        };
        Session.update({SessionCode : req.body.Data.SessionId, "Users.PhoneNumber" : phoneNo}, {"Users.$.Location" : copyData}, function (err, up) {
          if (err) {
            console.log(err);
            generateError(res, "You don't exist!");
          }
          else {
            res.json({"Status": "SUCCESS","Data": "LEGIT AND DONE" });
          }
        });
      }
    });
  }
});

router.get('/getPeopleInSession', function (req, res) {
  if (noErrorsIfDataNotSent(req.body.Data, ["SessionId", "PhoneNumber"], res)) {

     Session.findOne({SessionCode : req.body.Data.SessionId}, function (err, data) {
      if (err || data == null) {
        generateError(res, "Looks like this session token is not valid!");
      }
      else {
        var otherUsers = [];
        for (var x = 0; x < data.Users.length; x++) {
          if (data.Users[x].PhoneNumber != req.body.Data.PhoneNumber) {
            otherUsers.push({
              Name: data.Users[x].Name,
              Phone: data.Users[x].PhoneNumber,
              Preferences: data.Users[x].Cuisines
            });
          }
        }
        res.send({
          "Status" : "SUCCESS",
          "Data" : otherUsers
        })

      }
     });
  }
});

router.get('/getRestaurants', function (req, res) {
  if (noErrorsIfDataNotSent(req.body.Data, ["SessionId", "PhoneNumber"], res)) {
    Session.findOne({SessionCode : req.body.Data.SessionId}, function (err, data) {
      if (err || data == null) {
        generateError(res, "Looks like this session token is not valid!");
      }
      else if (data.Restaurants == null || data.Restaurants.length == 0 ) {
        if (data.Users.length < 1) {
           generateError(res, "This is not a valid sesion!");
        }
        else {
          var cusines = data.Users[0].Cuisines;
          var index = -1;
          for (var x = 0; x < data.Users.length; x++) {
              if (data.Users[x].PhoneNumber == req.body.Data.PhoneNumber) {
                index = x;
              }
          }
          if (index == -1) {
            generateError(res, "You are not in the session!");
          }
          else {
            yelpAPI(cusines, data.Users[index].Location.Latitude, data.Users[index].Location.Longitude, function (data) {
              console.log(data);
            })
          }
        }
      }
    }); 
  }
});



//Route 3 - Users in session
router.get("/:code/:number/", function (req, res) {
    var code = req.params.code;
    var number = req.params.number;

    Session.find({"sessionCode": code}, function (err, names) {
        if (err)
            res.send(err);

        var arr = [];
        for (var i = 0; i < names[0].users.length; i++) {
            var item = JSON.parse(JSON.stringify(names[0].users[i]))
            if (item.number != number) {
                arr.push(item);
            }
            res.send(arr);
        }
        ;
    });
});

//Route 4 - Generate restaurants
router.get("/:code/restaurants", function (req, res) {
    var code = req.params.code;

    //Collect all cuisine preferences from users
     Session.find({"sessionCode": code}, function (err, docs){
        if(err)
          res.send(err)
        console.log(docs);


     });

    //Filter + Create a Set from cuisine preferences

    //Split # of restaurants by preferences

    //query Yelp API on each / all of the categories to get list of restaurants

});




// YELP API


module.exports = router;
