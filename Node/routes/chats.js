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

function noErrorsIfDataNotSent(mainreqresbody, arroffields, res) {
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


// Get all messagess in session
router.post('/get/messages', function (req, res) {
    console.log("Getting chat");
    if (req.body.Data == null) {
        generateError(res, "No data sent");
    }
    else if (!checkDoesExistReqRes(req.body.Data, ["SessionId"])) {
        generateError(res, "Not all the required data has been sent");
    }
    else {
        Session.findOne({
            SessionCode: req.body.Data.SessionId
        }, function (err, data) {
            if (err || data == null) {
                generateError(res, "Looks like this session token is not valid!");
            }
            else {
                //if everything passes
                console.log("SUCCESS!")

                var messages = data.Messages;
                res.send({
                    "Status": "SUCCESS",
                    "Data": messages
                });
            }
        });
    }
});

// Get all messages from one user
router.post('/get/messages/user', function (req, res) {
    console.log("Getting chat from user");
    if (req.body.Data == null) {
        generateError(res, "No data sent");
    }
    else if (!checkDoesExistReqRes(req.body.Data, ["SessionId", "PhoneNumber"])) {
        generateError(res, "Not all the required data has been sent");
    }
    else {
        Session.findOne({
            SessionCode: req.body.Data.SessionId
        }, function (err, data) {
            if (err || data == null) {
                generateError(res, "Looks like this session token is not valid!");
            }
            else {
                //if everything passes
                console.log("SUCCESS!")

                var phoneNumber = req.body.Data.PhoneNumber;

                var userMessages = _.filter(data.Messages, {
                    'PhoneNumber': phoneNumber
                });
                res.send({
                    "Status": "SUCCESS",
                    "Data": userMessages
                });
            }
        });
    }
});

// Add a message to chat session
router.post('/messages/', function (req, res) {
    console.log("Adding message to session");
    if (req.body.Data == null) {
        generateError(res, "No data sent");
    }
    else if (!checkDoesExistReqRes(req.body.Data, ["SessionId", "PhoneNumber", "Message"])) {
        generateError(res, "Not all the required data has been sent");
    }
    else {
        var sessionCode = req.body.Data.SessionId
        Session.findOne({
            SessionCode: sessionCode
        }, function (err, data) {
            if (err || data == null) {
                generateError(res, "Looks like this session token is not valid!");
            }
            else {
                //if everything passes
                console.log("No errors")

                //Create local vars
                var phoneNumber = req.body.Data.PhoneNumber;
                var message = req.body.Data.Message;
                var name;
                var query = Session.find({
                    SessionCode: sessionCode
                }, 'Users');

                query.exec(function (err, user) {
                    if (err)
                        console.log(msg)
                    else {
                        var users = user[0].Users;
                        var userObject = _.filter(users, {
                            'PhoneNumber': phoneNumber
                        });
                        var name = userObject[0]["Name"]
                    }

                    //Instantiate new Message object
                    var newMessage = {
                        "Name": name,
                        "PhoneNumber": phoneNumber,
                        "Message": message
                    }

                    //Update DB
                    Session.update(
                        "SessionCode: sessionCode", {
                            $push: {
                                "Messages": newMessage
                            }
                        },
                        function (err, data) {});

                    res.send({
                        "Status": "SUCCESS",
                        "Data": message
                    });

                });


            }
        });
    }
});

module.exports = router;
