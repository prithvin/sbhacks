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
import EasyAnimation
import MessageUI
import SwiftyJSON

class TinderViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    var restaurantCode : Int! = 1111111;
    
    @IBOutlet var miniCardHeight: NSLayoutConstraint!
    @IBOutlet var whoIsInSession: UILabel!
    @IBOutlet var codeToInviteLabel: UILabel!
    var recipientsOfText = [String]();
    var hasBeenClicked : Bool = false;
    let pscope = PermissionScope();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        codeToInviteLabel.text = "Code to Invite:  \(restaurantCode)"
      

        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                        didFinishWithResult result: MessageComposeResult) {
    }
    @IBOutlet var actualKoladaView: ActualCardKolodaView!
    
    @IBAction func createGroupChat(sender: AnyObject) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = recipientsOfText;
        composeVC.body = "Hello from California!"
        
        // Present the view controller modally.
        self.presentViewController(composeVC, animated: true, completion: nil)
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
    @IBOutlet var miniCard: UIView!
    @IBAction func hideOrShowMiniCard(sender: AnyObject) {
      //  miniCardHeight
        if (!hasBeenClicked) {
            hasBeenClicked = true;
            if ( miniCard.frame.origin.y == self.view.frame.height - 70) {
                UIView.animateWithDuration(0.5, delay: 0.0, options: [ .CurveEaseOut],
                animations: {
                    
                    self.miniCard.frame.origin.y = self.view.frame.height - 150;
                    print( self.miniCard.frame.origin.y);
                    print(self.view.frame.height);
                    }, completion: {
                        (omg : Bool) in
                        self.hasBeenClicked = false;
                });
            }
            else {
                UIView.animateWithDuration(0.5, delay: 0.0, options: [ .CurveEaseOut],
                animations: {
                    self.miniCard.frame.origin.y  = self.view.frame.height - 70;
                    print( self.miniCard.frame.origin.y);
                    print(self.view.frame.height);
                    }, completion: {
                        (omg : Bool) in
                        self.hasBeenClicked = false;
                });
            }
            
        }
    }

    override func viewDidAppear(animated: Bool) {
        
        pscope.addPermission(LocationWhileInUsePermission(),
                             message: "We want to send you to Indranil's house.")
          self.miniCard.frame.origin.y  = self.view.frame.height - 70;
        AppDelegate.sharedInstanceAPI.getPeopleInSession(callback: {
            (data : JSON!) in
            
            if (data != nil) {
                var str : String = "This session is with ";
                var x = 0;
                for x in 0 ..< data.count {
                    str += (data[x].dictionary!["Name"]?.stringValue)! + ", ";
                    self.recipientsOfText.append((data[x].dictionary!["Phone"]?.stringValue)!);
                }
                self.whoIsInSession.text = str;
            }
        })

        
        
        showPermissionView({
           // let locationManager = CLLocationManager();
           // let value = locationManager.location!;
            let latitude = 34.4116;
            let longitude = -119.845;
            
            AppDelegate.sharedInstanceAPI.saveLatLong(latitude: latitude, longitude: longitude, callback: {
                (str : String!) in
                
                self.actualKoladaView.fetchOtherData();
                if (str == nil) {
                    
                }
                else {
                    
                    // go on to fetch cards, restuarnats and all that shit
                }
            })
 
        });
        miniCard.frame.origin.y = self.view.frame.height - 70;
    }
    
    func showPermissionView (completion: () -> Void) {
        pscope.show({ finished, results in
            if finished && results[0].status != .Authorized {
                self.userNotExpectedPermission();
               
                
            }
            else if finished {
                completion();
                

                
         
                    
   

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
            self.showPermissionView({
                //let locationManager = CLLocationManager();
               // let value = locationManager.location!;
                let latitude = 34.4116;
                let longitude = -119.845;
                
                AppDelegate.sharedInstanceAPI.saveLatLong(latitude: latitude, longitude: longitude, callback: {
                    (str : String!) in
                    
                    self.actualKoladaView.fetchOtherData();
                    if (str == nil) {
                        
                    }
                    else {
                        
                        // go on to fetch cards, restuarnats and all that shit
                    }
                })

            });
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
