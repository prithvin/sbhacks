//
//  NameViewController.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import UIKit
import TextFieldEffects
import SCLAlertView

class NameViewController: UIViewController, UITextFieldDelegate {

    var nextCount = 0; // count increases once next is pressed once
    @IBOutlet var nameField: YoshikoTextField!
    @IBOutlet var nameLabel: UILabel!
    var creatingNewSession  : Int!;
    var name : String!;
    var cuisine : String!;
    var phone : String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        reAnimateView(nil, currPosInputBefore: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

    
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                changeBottom.constant = keyboardHeight;
                print(self.nextButton.frame.origin.y)

            }
        }
    }
    
    
    @IBOutlet var changeBottom: NSLayoutConstraint!
    @IBOutlet var nextButton: UIButton!
    
    func textFieldShouldReturn( textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        nextButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside);
        changeBottom.constant = 0;
        return true;
    }
    
    @IBAction func pressedNext(sender: AnyObject) {
        // send Data to databse
        
        if (nextCount == 0) {
            // do database sending for Name
            
            if (nameField.text!.characters.count < 3 ||
                nameField.text!.characters.indexOf(" ") == nil) {
                SCLAlertView().showError("Invalid Name", subTitle: "Please provide your full name") // Error
            }
            else {
                name = self.nameField.text;
                self.preAnimateView({
                    self.nameField.placeholder = "Phone Number";
                    self.nameField.keyboardType = UIKeyboardType.NumberPad;
                    self.nameField.text = "";
                    self.nameField.resignFirstResponder(); // makes it so that nameFiled is not selected if it is already
                
                    self.nameLabel.text = "What's your phone number?";
                    changeBottom.constant = 0
                });
                
                nextCount += 1;
            }
        }
        else if (nextCount == 1) {
            // do database sending for phone number
            //verify for phone number
            if ((nameField.text!.characters.count < 5)) {
                SCLAlertView().showError("Invalid Phone Number", subTitle: "Please provide a valid phone number") // Error
            }
            else {
                phone = (self.nameField.text);
                self.preAnimateView({
                    self.nameField.placeholder = "Cusines";
                    self.nameField.keyboardType = UIKeyboardType.NumberPad;
                    self.nameField.text = "";
                    self.nameField.resignFirstResponder(); // makes it so that nameFiled is not selected if it is already
                    self.nameField.keyboardType = UIKeyboardType.Default;
                    self.nameLabel.text = "What type of food do you like?";
                    changeBottom.constant = 0;
                });
                nextCount += 1;
            }
            
            
        }
        else {
            cuisine = self.nameField.text;
            
            // meaning that the session id is not there, so this means that you need ot create a new 
            // session rather than pass a new session in
            if (creatingNewSession == nil) {
                AppDelegate.sharedInstanceAPI.createNewSession(nameOfUser: name, phoneOfUser: phone, cuisine: cuisine, callback: {
                    (str : String!) in
            
                    if (str == nil) {
                        
                    }
                    else {
                        let nextViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TinderViewController") as! TinderViewController;
                        nextViewController.restaurantCode = Int(str!);
                        nextViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal;
                        self.presentViewController(nextViewController, animated: true, completion:nil);
                    }
            
                });
            }
            else {
                AppDelegate.sharedInstanceAPI.joinUserSession(nameOfUser: name, phoneOfUser: phone, cuisine: cuisine, sessionId: creatingNewSession,  callback: {
                    (str : String!) in
                    
                    if (str == nil) {
                        
                    }
                    else {
                        let alertView = SCLAlertView();
                        alertView.addButton("Ok!") {
                            
                            let nextViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TinderViewController") as! TinderViewController;
                            
                            // passing in session code
                            nextViewController.restaurantCode = self.creatingNewSession!;
                            nextViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal;
                            self.presentViewController(nextViewController, animated: true, completion:nil);
                            
                        }
                        alertView.showCloseButton = false;
                        alertView.showSuccess(":)", subTitle: str) // Errors
                        
                        
                    }
                    
                });
            }
        }
    }
    
    
    func preAnimateView (completeChangingNames: () -> Void) {
        let tempLabel =  self.nameLabel.frame.origin.y;
        let tempField = self.nameField.frame.origin.y;
        UIView.animateWithDuration(1.0,
                                   animations: {
                                    
                                    self.nameLabel.frame.origin.y = -100;
                                    self.nameField.frame.origin.y = 500;
                                    completeChangingNames();
            }, completion: {
                (test: Bool) in
                print("HEY");
                //self.reAnimateView(tempLabel, currPosInputBefore: tempField);
            }
        );
    }
    
    func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    func reAnimateView (currPosLabelBefore: CGFloat!, currPosInputBefore: CGFloat!) {
        
        nameField.hidden = true;
        nameLabel.hidden = true;
        
        
        // hide all the current stuff!
        var currLabelPosition = nameLabel.frame.origin.y;
        var currInputPosition = nameField.frame.origin.y;
        if currPosLabelBefore != nil {
            currLabelPosition = currPosLabelBefore!;
        }
        if currPosInputBefore != nil {
            currInputPosition = currPosInputBefore!;
        }
        
        nameField.frame.origin.y = view.frame.height + 500; // put it all the way on bottom of screen
        nameLabel.frame.origin.y = view.frame.height + 500; // put it all the way on bottom of screen
        
        animateAppearance(currLabelPosition, fieldFinalPos: currInputPosition); // animates appearence

    }
    
    func animateAppearance (labelFinalPos: CGFloat, fieldFinalPos: CGFloat) {
        nameField.hidden = false;
        nameLabel.hidden = false;
        UIView.animateWithDuration(1.0, animations: {
            self.nameLabel.frame.origin.y = labelFinalPos - 200;
            self.nameField.frame.origin.y = fieldFinalPos - 200;
        });
        UIView.animateWithDuration(1.0, animations: {
            self.nameLabel.frame.origin.y = labelFinalPos;
            self.nameField.frame.origin.y = fieldFinalPos;
        });
        
        
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
