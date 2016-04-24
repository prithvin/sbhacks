var mongoose = require('mongoose');
var Schema = mongoose.Schema; //Initialize Schema

var sessionSchema = new Schema ({	//LATER - Trim schema
    session: String,
    number: Number,
    restaurants: [String],
    session: Number
});

module.exports = mongoose.model('sessionCollection', sessionSchema,'Users');