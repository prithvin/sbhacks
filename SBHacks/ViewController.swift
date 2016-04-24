//
//  ViewController.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import UIKit
import SCLAlertView
import TextFieldEffects

class ViewController: UIViewController {

    @IBOutlet var sessionId: YoshikoTextField!
    
    @IBOutlet var labelToMove: UILabel!
    @IBOutlet var joinSessionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func joinSessionWithId(sender: AnyObject) {
        
        // error, invalid sessionid
        if (sessionId.text!.characters.count != 6) {
            SCLAlertView().showError("Incorrect Session ID", subTitle: "Your session ID must be 6 characters long.") // Error
        }
        else {
            askForName(true);
        }
        
        // then ask for Name and Phone
    }

    @IBAction func createSession(sender: AnyObject) {
        
        askForName(false);
        
        // then ask for Name and Phone
    }
    
    func askForName (oldSession: Bool) {
        let nextViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NameViewController") as! NameViewController
        animateAndHideTops({
            if (oldSession == true) {
                nextViewController.creatingNewSession = Int(self.sessionId.text!);
            }
            self.presentViewController(nextViewController, animated: false, completion:nil)
        });
        //nextViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
       
    }
    

    func animateAndHideTops (completion: () -> Void) {
        UIView.animateWithDuration(1.0, delay: 0.0, options: [ .CurveEaseOut],
            animations: {
                self.joinSessionButton.frame.origin.y = -500;
                self.sessionId.frame.origin.y = -500;
                self.labelToMove.frame.origin.y = -500;
            }, completion: {
                (value: Bool) in
                completion();
        })

    }
}

