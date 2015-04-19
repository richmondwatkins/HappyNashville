//
//  DetailViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/16/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

protocol DetialViewModelProtocol {
    func scrollPageViewControllertoDay(indexPath: NSIndexPath)
}

class DetailViewModel: NSObject {
    
    var weekLookup: Array<String> = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var dataSource: Array<DealDay> = []
    var calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    var hasCurrentDay: Bool!
    var delegate:DetialViewModelProtocol?
    
     init(dealDays: Array<DealDay>) {
        super.init()
        self.dataSource = sorted(dealDays, {
            (day1: DealDay, day2: DealDay) -> Bool in
            return day1.day.integerValue < day2.day.integerValue
        })
        
        self.hasCurrentDay = isTodayIncluded()
    }
    
    func getCurrentDay() -> Int {
        
        var dateComponents = self.calendar!.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: NSDate())
        
        return dateComponents.weekday
    }
    
    func dayLabelText(dealDay: DealDay) -> String {
        
        if dealDay.day.integerValue == getCurrentDay() {
            return "Today"
        } else {
            
             return self.weekLookup[dealDay.day.integerValue]
        }
    }
    
    func dateLabelText(indexPath: NSIndexPath) -> String {
        
        var dateComponents = NSDateComponents()
        
        var dealDay: DealDay = self.dataSource[indexPath.row]
        
        dateComponents.day = dealDay.day.integerValue - getCurrentDay()
        
        var dateForIndex: NSDate = self.calendar!.dateByAddingComponents(dateComponents, toDate: NSDate(), options: nil)!
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd";
        
        return dateFormatter.stringFromDate(dateForIndex)
    }
    
    func isTodayIncluded() -> Bool {
        
        for dealDay in self.dataSource {
            if dealDay.day == getCurrentDay() {
                return true
            }
        }
        
        return false
    }
    
    func configureSelected(cell: DayCollectionViewCell, indexPath: NSIndexPath) {
        
        let dealDay: DealDay = self.dataSource[indexPath.row]
        
        if self.hasCurrentDay == true {
            if dealDay.day.integerValue == getCurrentDay() {
                cell.selectedView.backgroundColor = UIColor.blackColor()
                cell.isCurrentDay = true
                delegate?.scrollPageViewControllertoDay(indexPath)
            } else if(cell.isCurrentDay) {
                cell.selectedView.backgroundColor = UIColor.clearColor()
            }
        } else if (indexPath.row == 0) {
            cell.selectedView.backgroundColor = .blackColor()
        }
    }
}
