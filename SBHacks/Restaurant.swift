//
//  File.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import Foundation
import UIKit

class Restaurant {
    
    var siteURL : String;
    var restaurantName : String;
    var restaurantCategories : String;
    var distance : String;
    var numberOfReviews : Int;
    
    
    var imageURLOfRestaurant: String;
    var imageURLOfReviews : String;
    var restaurantImage : UIImage!;
    var reviewsImage : UIImage!;
    
    init (yelpURL : String, restaurantName : String, restaurantCategories : String, distance : String, numberOfReviews : Int, imageURLOfRestaurant: String, imageURLOfReviews : String) {
        
        self.siteURL = yelpURL;
        self.restaurantName = restaurantName;
        self.restaurantCategories = restaurantCategories;
        self.distance = distance;
        self.numberOfReviews = numberOfReviews;
        self.imageURLOfRestaurant = imageURLOfRestaurant;
        self.imageURLOfReviews = imageURLOfReviews;
        
        
        let url = NSURL(string: imageURLOfRestaurant)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.restaurantImage = UIImage(data: data!);
        
        let url2 = NSURL(string: imageURLOfReviews)
        let data2 = NSData(contentsOfURL: url2!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.reviewsImage = UIImage(data: data2!);
        
    
    }
    
    
    func loadImages (completion: () -> Void) {
        if let checkedUrl = NSURL(string: self.imageURLOfRestaurant) {
            downloadImage(checkedUrl, callback: {
                (img : UIImage) in
                self.restaurantImage = img;
                if let checkedUrl = NSURL(string: self.imageURLOfReviews) {
                    self.downloadImage(checkedUrl, callback: {
                        (img : UIImage) in
                        self.reviewsImage = img;
                        completion();
                    })
                }
            })
        }
       
        
    }
    
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, callback: (UIImage) -> Void) {
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                callback(UIImage(data: data)!);
            }
        }
    }
}