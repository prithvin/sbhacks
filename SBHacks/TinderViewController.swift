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

class TinderViewController: UIViewController {

    var restaurantCode : String! = "XXXXXX";
    
    @IBOutlet var codeToInviteLabel: UILabel!
    let pscope = PermissionScope();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        codeToInviteLabel.text = "Code to Invite: " + restaurantCode;

        // Do any additional setup after loading the view.
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
