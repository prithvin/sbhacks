//
//  ActualCardKolodaView.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import UIKit
import Koloda
import SwiftyJSON

class ActualCardKolodaView: KolodaView, KolodaViewDelegate, KolodaViewDataSource {
    
    var currentNib = [UIView!](); // stack
    var objectDataSource = [Restaurant]();
    
    func fetchOtherData () {
        AppDelegate.sharedInstanceAPI.getRestaurants(callback: {
            (jsonFile: JSON!) in
            if (jsonFile != nil) {
                
                var x = 0;
                for x in 0..<jsonFile.count {
                    
                    
                    self.objectDataSource.append(Restaurant(
                        yelpURL: jsonFile[x].dictionary!["id"]!.stringValue,
                        restaurantName: jsonFile[x].dictionary!["title"]!.stringValue ,
                        restaurantCategories: jsonFile[x].dictionary!["category"]!.stringValue ,
                        distance: jsonFile[x].dictionary!["distance"]!.stringValue,
                        numberOfReviews: jsonFile[x].dictionary!["reviewCount"]!.intValue,
                        imageURLOfRestaurant: jsonFile[x].dictionary!["imageURL"]!.stringValue,
                        imageURLOfReviews: jsonFile[x].dictionary!["reviewImage"]!.stringValue
                        ));
                }
            }
            self.reloadData();
        });

    }
    
    
    override func awakeFromNib() {
        self.delegate = self;
        self.dataSource = self;
    
                
        
        
        // arr count loaded in
        
    }
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(objectDataSource.count);
        //return UInt(objectDataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
    
        return OverlayView();
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        if (direction == SwipeResultDirection.Left) {
          
            
        }
            // Upvoting API
        else {
            let id = objectDataSource[Int(index)].siteURL;
            AppDelegate.sharedInstanceAPI.likeRestaurant(restaurantId: id, callback: {
                (json : JSON!) in
            });
            
        }
        currentNib.removeFirst();
    }
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let restaurantData = objectDataSource[Int(index)];

        let newView = (NSBundle.mainBundle().loadNibNamed("CardRestaurantView",
            owner: self, options: nil)[0] as! CardRestaurantView);
        newView.getRestaurant(restaurantData);
        
        currentNib.append(newView);
        
        return currentNib[currentNib.count - 1]; // last element pushed on the stack
    }
    
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        
    }
    
    func koloda(koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, inDirection direction: SwipeResultDirection) {
   
        
        if let view = currentNib[0] as! CardRestaurantView! {
            view.showBackgroundStuffBasedOnPercentage(finishPercentage, inDirection: direction);
        }
    }
    
}
