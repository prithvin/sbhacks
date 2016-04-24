//
//  ActualCardKolodaView.swift
//  SBHacks
//
//  Created by Prithvi Narasimhan on 4/23/16.
//  Copyright © 2016 SBHacks. All rights reserved.
//

import UIKit
import Koloda

class ActualCardKolodaView: KolodaView, KolodaViewDelegate, KolodaViewDataSource {
    
    let objectDataSource = [Restaurant]();
    override func awakeFromNib() {
        self.delegate = self;
        self.dataSource = self;
        
        
        
        // arr count loaded in
    }
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return 2;
        //return UInt(objectDataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
    
        return OverlayView();
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        
    }
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let nib = NSBundle.mainBundle().loadNibNamed("CardRestaurantView",
                                                    owner: self, options: nil)[0] as! CardRestaurantView;
        return nib;
    }
    
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {

    }
    
    func koloda(koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, inDirection direction: SwipeResultDirection) {
        
    }
    
}
