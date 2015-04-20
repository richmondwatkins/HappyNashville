//
//  AppViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/19/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class AppViewModel: NSObject {
   
    
    func getCurrentDay() -> Int {
        
        var calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        
        var dateComponents = calendar!.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: NSDate())
        
        return dateComponents.weekday
    }
    
    func sortSpecialsByTime(specials: NSSet) -> NSArray {
        
        var specialsArray: NSMutableArray = NSMutableArray(array: specials.allObjects)
        
        return NSArray(array: specials.sortedArrayUsingDescriptors([NSSortDescriptor(key: "hourStart", ascending: true)]))
    }
    
    func getButtonWidth(parentViewWidth: CGFloat, numberOfButtons: CGFloat) -> (buttonWidth: CGFloat, buttonPadding: CGFloat) {
        
        let paddingSeperators: CGFloat = 2
        
        var buttonPadding:CGFloat = 5 * paddingSeperators
        
        var buttonWidth:CGFloat = (parentViewWidth - buttonPadding) / numberOfButtons
        
        return (buttonWidth, 5)
    }
}
