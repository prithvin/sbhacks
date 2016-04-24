//
//  CardRestaurantView.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import UIKit

import Koloda
class CardRestaurantView: UIView {
    
    @IBOutlet var reviewsURL: UIImageView!
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet var restaurantImage: UIImageView!
    @IBOutlet var restaurantCategories: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var numberReviews: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var imageBack: UIImageView!
    
    override func awakeFromNib() {
        backgroundView.layer.opacity = 0;
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.lightGrayColor().CGColor;
    }
    
    func showBackgroundStuffBasedOnPercentage (percentSwiped : CGFloat, inDirection: SwipeResultDirection) {
        
        if (inDirection == SwipeResultDirection.Left) {

            imageBack.image = UIImage(named: "sad_tinder");
            backgroundView.layer.opacity = Float(percentSwiped/76.0);
        }
        else if (inDirection == SwipeResultDirection.Right) {
            
            imageBack.image = UIImage(named: "happy_tinder");
            backgroundView.layer.opacity = Float(percentSwiped/76.0);
        }
    }
    
    func getRestaurant(item: Restaurant) {
        reviewsURL.image = item.reviewsImage;
        restaurantName.text = item.restaurantName;
        restaurantImage.image = item.restaurantImage;
        restaurantCategories.text = item.restaurantCategories;
        distance.text = item.distance;
        numberReviews.text = "\(item.numberOfReviews) reviews";
    }
    
}
