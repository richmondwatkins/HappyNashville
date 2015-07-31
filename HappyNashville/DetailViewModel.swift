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
    
    var weekLookup: Array<String> = ["", "S", "M", "T", "W", "Th", "F", "S"]
    var dataSource: Array<DealDay> = []
    var calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    var hasCurrentDay: Bool!
    var delegate:DetialViewModelProtocol?
    var currentDayCell: DayCollectionViewCell?
    var currentCellIndex: Int = Int()
    var originalConfigCount: Int = Int()
    var selectedDay: DealDay!
    
    init(dealDays: Array<DealDay>, selectedDate: DealDay?) {
        super.init()
        
        self.dataSource = dealDays.sort({
            (day1: DealDay, day2: DealDay) -> Bool in
            return day1.day.integerValue < day2.day.integerValue
        })
        
        self.selectedDay = selectedDate
        self.hasCurrentDay = isTodayIncluded()
    }
    
    func dayLabelText(dealDay: DealDay) -> String {
        
        return self.weekLookup[dealDay.day.integerValue]
    }
    
    func dateLabelText(indexPath: NSIndexPath) -> String {
        
        let dateComponents = NSDateComponents()
        
        let dealDay: DealDay = self.dataSource[indexPath.row]
        
        dateComponents.day = dealDay.day.integerValue - getCurrentDay()
        
        let dateForIndex: NSDate = self.calendar!.dateByAddingComponents(dateComponents, toDate: NSDate(), options: [])!
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
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
        
        if self.currentDayCell != nil {
             self.currentDayCell!.selectedView.backgroundColor = .clearColor()
        }
       
        cell.selectedView.backgroundColor = UIColor(hexString: "3d3d3e")
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
            
            if let selectedDealDay = self.selectedDay {
                if selectedDealDay.day.integerValue == dealDay.day.integerValue {
                    cell.selectedView.backgroundColor = UIColor(hexString: "3d3d3e")
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
