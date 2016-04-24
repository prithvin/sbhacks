//
//  APICaller.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

class APICaller {
    
    var session : String!;
    var userPhoneNumber : String!;
    let baseURL = "http://forkchop-62260.onmodulus.net/api/";
    
    let MAKE_RECURSIVE_CALL = 3;
    let SUCCESS = 1;
    let ERROR = 2;
    

    func getPeopleInSession(queryNum:Int = 0, callback : (JSON!) -> Void) {
        let parameters = ["SessionId" : session, "PhoneNumber" : userPhoneNumber];
        
        quickAPICaller("getPeopleInSession", parameters: parameters, type: Alamofire.Method.POST, queryNum: queryNum, callback: {
            (status : Int, data : JSON!) in
            
            if (status == self.MAKE_RECURSIVE_CALL) {
                self.getPeopleInSession(queryNum + 1, callback: callback);
            }
                
            else if (status == self.ERROR) {
                callback(nil);
            }
            else if (status == self.SUCCESS) {
                callback(data);
            }
        });

    }
    
    func createNewSession (queryNum:Int = 0, nameOfUser : String, phoneOfUser: String, cuisine : String, callback : (String!) -> Void) {
        let parameters = ["Name" : nameOfUser, "PhoneNumber" : phoneOfUser,  "Cuisine" : cuisine];
        
        quickAPICaller("create", parameters: parameters, type: Alamofire.Method.POST, queryNum: queryNum, callback: {
            (status : Int, data : JSON!) in

            if (status == self.MAKE_RECURSIVE_CALL) {
                self.createNewSession(queryNum + 1, nameOfUser: nameOfUser, phoneOfUser: phoneOfUser, cuisine : cuisine, callback: callback);
            }
            
            else if (status == self.ERROR) {
                callback(nil);
            }
            else if (status == self.SUCCESS) {
                callback(data.stringValue);
                self.session = data.stringValue;
                self.userPhoneNumber = phoneOfUser;
            }
        });
    }
    
    func joinUserSession (queryNum:Int = 0, nameOfUser : String, phoneOfUser: String, cuisine : String, sessionId: Int, callback : (String!) -> Void) {
        let parameters = ["Name" : nameOfUser, "PhoneNumber" : phoneOfUser,  "Cuisine" : cuisine, "SessionId": sessionId];
        
 
        
        quickAPICaller("joinSession", parameters: parameters, type: Alamofire.Method.POST, queryNum: queryNum, callback: {
            (status : Int, data : JSON!) in
            
            
            
            if (status == self.MAKE_RECURSIVE_CALL) {
                self.joinUserSession(queryNum + 1, nameOfUser: nameOfUser, phoneOfUser: phoneOfUser, cuisine : cuisine, sessionId: sessionId,  callback: callback);
            }
                
            else if (status == self.ERROR) {
                callback(nil);
            }
            else if (status == self.SUCCESS) {
                callback(data.stringValue);
                self.session = "\(sessionId)"; // different here b/c success retursn other things
                self.userPhoneNumber = phoneOfUser;
            }
        });
    }
    
    func saveLatLong (queryNum:Int = 0, latitude : Double, longitude: Double, callback : (String!) -> Void) {
        
        let parameters = ["Latitude" : latitude, "Longitude" : longitude,  "SessionId" : session, "PhoneNumber": userPhoneNumber];
        
        quickAPICaller("saveLatLong", parameters: parameters, type: Alamofire.Method.POST, queryNum: queryNum, callback: {
            (status : Int, data : JSON!) in
            
            if (status == self.MAKE_RECURSIVE_CALL) {
                self.saveLatLong(queryNum + 1, latitude : latitude, longitude : longitude, callback: callback);
            }
                
            else if (status == self.ERROR) {
                callback(nil);
            }
            else if (status == self.SUCCESS) {
                callback(data.stringValue);
            }
        });
    }
    
    
    
    

}

extension APICaller {
    
    
    // endpoint = \new _-. must include \
    
    // returns 1 if success, along iwth Data ["1", Data] array type
    // returns 2 if failure
    // returns 3 if recursive call required
    func quickAPICaller (endPoint : String, parameters: NSDictionary, type: Alamofire.Method, queryNum: Int, callback: (Int, JSON!) -> Void) {
        
        
    
        Alamofire.request(type, "\(baseURL)\(endPoint)", parameters: ["Data": parameters], encoding: .JSON)
            .responseJSON { response in
                
                if (response.result.isSuccess) {
                    
           
                    
                    var data : SwiftyJSON.JSON = SwiftyJSON.JSON(response.result.value!);
            
  
                    if (data["Status"].stringValue == "SUCCESS") {
                        
                        self.session = data["Data"].stringValue;
                        
                        
                        callback(self.SUCCESS, data["Data"]);
                    }
                    else if (data["Status"].stringValue == "ERROR") {
                        SCLAlertView().showError("Uh Oh!", subTitle: data["Data"].stringValue);
                        callback(self.ERROR, nil);
                    }
                }
                else if (queryNum < 3) {
                    callback(self.MAKE_RECURSIVE_CALL, nil);
                }
                else {
                    self.errorDisplayer();
                    callback(self.ERROR, nil);
                }
        }
    }
    
    
    func getTopViewController()->UIViewController{
        return topViewControllerWithRootViewController(UIApplication.sharedApplication().keyWindow!.rootViewController!)
    }
    func topViewControllerWithRootViewController(rootViewController:UIViewController)->UIViewController{
        if rootViewController is UITabBarController{
            let tabBarController = rootViewController as! UITabBarController
            return topViewControllerWithRootViewController(tabBarController.selectedViewController!)
        }
        if rootViewController is UINavigationController{
            let navBarController = rootViewController as! UINavigationController
            return topViewControllerWithRootViewController(navBarController.visibleViewController!)
        }
        if let presentedViewController = rootViewController.presentedViewController {
            return topViewControllerWithRootViewController(presentedViewController)
        }
        return rootViewController
    }
    func errorDisplayer () {
        let alertView = SCLAlertView();
        alertView.showError("Uh Oh!", subTitle: "Something happened! Please try again later.") // Errors
    }
}