var mongoose = require('mongoose');
var Schema = mongoose.Schema; //Initialize Schema

var sessionSchema = new Schema({ //LATER - Trim schema
    SessionCode: String,
    Messages: [{
        "Name": String,
        "PhoneNumber": Number,
        "Message": String,
        "Created": {
            type: Date,
            default: Date.now
        }
    }],
    Users: [{
        "Name": String,
        "PhoneNumber": Number, // Number is unique ID here
        "Cuisines": String,
        "Location": {
            "Latitude": Number,
            "Longitude": Number
        }
    }],
    "Restaurants": [{
        "YelpID": String,
        "NameOfRestaurant": String,
        "Votes": [Number], // Number is unique ID here (Phone number of people who voted)
        "Location": {
            Latitude: Number,
            Longtitude: Number
        } // Latitutde and Longtitude only
    }]
});

module.exports = mongoose.model('sessionCollection', sessionSchema, 'Sessions');
