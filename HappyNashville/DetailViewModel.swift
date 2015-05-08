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

class DetailViewModel: AppViewModel {
    
    var weekLookup: Array<String> = ["", "S", "M", "T", "W", "T", "F", "S"]
    var dataSource: Array<DealDay> = []
    var calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    var hasCurrentDay: Bool!
    var delegate:DetialViewModelProtocol?
    var currentDayCell: DayCollectionViewCell?
    var currentCellIndex: Int = Int()
    var originalConfigCount: Int = Int()
    
     init(dealDays: Array<DealDay>) {
        super.init()
        self.dataSource = sorted(dealDays, {
            (day1: DealDay, day2: DealDay) -> Bool in
            return day1.day.integerValue < day2.day.integerValue
        })
        
        self.hasCurrentDay = isTodayIncluded()
    }
    
    func dayLabelText(dealDay: DealDay) -> String {
            
        return self.weekLookup[dealDay.day.integerValue]
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
    
    func setNewSelectedCell(cell: DayCollectionViewCell, index: Int) -> UIPageViewControllerNavigationDirection? {
        self.currentDayCell!.selectedView.backgroundColor = .clearColor()
        cell.selectedView.backgroundColor = .blackColor()
        self.currentDayCell = cell
        
        if self.currentCellIndex < index {
            self.currentCellIndex = index
            return UIPageViewControllerNavigationDirection.Forward
        } else if (self.currentCellIndex > index) {
            self.currentCellIndex = index
            return UIPageViewControllerNavigationDirection.Reverse
        } else {
            return nil
        }
    }
    
    func configureSelected(cell: DayCollectionViewCell, indexPath: NSIndexPath) {
        
        if self.originalConfigCount <= self.dataSource.count {
            let dealDay: DealDay = self.dataSource[indexPath.row]
            
            if self.hasCurrentDay == true {
                if dealDay.day.integerValue == getCurrentDay() {
                    cell.selectedView.backgroundColor = UIColor.blackColor()
                    delegate?.scrollPageViewControllertoDay(indexPath)
                    self.currentDayCell = cell
                    self.currentCellIndex = indexPath.row
                } else if(self.currentDayCell == cell) {
                    cell.selectedView.backgroundColor = UIColor.clearColor()
                }
            } else if (indexPath.row == 0) {
                cell.selectedView.backgroundColor = .blackColor()
                self.currentDayCell = cell
                self.currentCellIndex = indexPath.row
            }
            
            self.originalConfigCount++
        }
    }
}
