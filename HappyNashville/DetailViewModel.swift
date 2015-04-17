//
//  DetailViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/16/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class DetailViewModel: NSObject {
    
    var dataSource: Array<String> = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
   var calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    
    override init() {
        super.init()
        
    }
    
    func getCurrentDay() -> Int {
        
        var dateComponents = self.calendar!.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: NSDate())
        
        return dateComponents.weekday
    }
    
    func dayLabelText(indexPath: NSIndexPath) -> String {
        
        if indexPath.row == getCurrentDay() {
            return "Today"
        } else {
            return self.dataSource[indexPath.row]
        }
    }
    
    func dateLabelText(indexPath: NSIndexPath) -> String {
        
        var dateComponents = NSDateComponents()
        
        dateComponents.day = indexPath.row - getCurrentDay()
        
        var dateForIndex: NSDate = self.calendar!.dateByAddingComponents(dateComponents, toDate: NSDate(), options: nil)!
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd";
        
        return dateFormatter.stringFromDate(dateForIndex)
    }
    
    func configureSelected(cell: DayCollectionViewCell, indexPath: NSIndexPath) {
        
        if indexPath.row == getCurrentDay() {
            cell.selectedView.backgroundColor = UIColor.blackColor()
        }
    }
}
