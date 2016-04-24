//
//  TinderViewController.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import UIKit
import PermissionScope
import SCLAlertView
import CoreLocation

class TinderViewController: UIViewController {

    var restaurantCode : Int! = 1111111;
    
    @IBOutlet var codeToInviteLabel: UILabel!
    let pscope = PermissionScope();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        codeToInviteLabel.text = "Code to Invite:  \(restaurantCode)"

        // Do any additional setup after loading the view.
    }
    @IBAction func codeToInviteAlert(sender: AnyObject) {
        SCLAlertView().showTitle(
            "Invite People to Join", // Title of view
            subTitle: "Share the code with your friends and help", // String of view
            duration: 2.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Ok", // Optional button value, default: ""
            style: SCLAlertViewStyle.Info, // Styles - see below.
            colorStyle: 0xA429FF,
            colorTextButton: 0xFFFFFF
        );
        
        
    }

    override func viewDidAppear(animated: Bool) {
        
        pscope.addPermission(LocationWhileInUsePermission(),
                             message: "We want to send you to Indranil's house.")
        showPermissionView();
        
    }
    
    func showPermissionView () {
        pscope.show({ finished, results in
            if finished && results[0].status != .Authorized {
                self.userNotExpectedPermission();
               
                
            }
            else {
                let locationManager = CLLocationManager();
                let latitude = locationManager.location!.coordinate.latitude;
                let longitude = locationManager.location!.coordinate.longitude;
                
                AppDelegate.sharedInstanceAPI.saveLatLong(latitude: latitude, longitude: longitude, callback: {
                    (str : String!) in
                    if (str == nil) {
                        
                    }
                    else {
                        // go on to fetch cards, restuarnats and all that shit
                    }
                })
         
                    
   

                // send latitutde and longtiutde to the backend
                
            }
            }, cancelled: { (results) -> Void in
                self.userNotExpectedPermission();
        })
    }
    
    @IBAction func shareCode(sender: AnyObject) {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func userNotExpectedPermission () {
        let alertView = SCLAlertView();
        alertView.addButton("Ok!") {
            self.showPermissionView();
        }
        alertView.showCloseButton = false;
        alertView.showError("Uh Oh!", subTitle: "We need your location to help find restaurants nearby!") // Errors
    }
    
    @IBAction func quitWindow(sender: AnyObject) {
        let nextViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController;
        nextViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal;
            
            
        self.presentViewController(nextViewController, animated: true, completion:nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
