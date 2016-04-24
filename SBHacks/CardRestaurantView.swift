//
//  CardRestaurantView.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import UIKit

class CardRestaurantView: UIView {
    
    @IBOutlet var reviewsURL: UIImageView!
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet var restaurantImage: UIImageView!
    @IBOutlet var restaurantCategories: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var numberReviews: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.lightGrayColor().CGColor;
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
