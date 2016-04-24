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
        loadImages();
    }
    
    
    func loadImages () {
        if let checkedUrl = NSURL(string: self.imageURLOfRestaurant) {
            downloadImage(checkedUrl, callback: {
                (img : UIImage) in
                self.restaurantImage = img;
            })
        }
        if let checkedUrl = NSURL(string: self.imageURLOfReviews) {
            downloadImage(checkedUrl, callback: {
                (img : UIImage) in
                self.reviewsImage = img;
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