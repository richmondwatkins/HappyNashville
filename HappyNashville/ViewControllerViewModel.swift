//
//  ViewControllerViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 3/31/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreData

@objc protocol ViewModelProtocol {
    func reloadTable()
}


 class ViewControllerViewModel: AppViewModel, NSFetchedResultsControllerDelegate {
    
    var tableDataSource: Dictionary<Int, Array<DealDay>> {
        
        get {
            if isFiltered {
                
                return self.filteredTableDataSource
            }
            
            return self.originalDataSource
        }
        
        set {
            
        }
    }
    var originalDataSource: Dictionary<Int, Array<DealDay>> = [:]
    var delegate: ViewModelProtocol?
    var tableSections: Array<Int> = []
    var unformattedData: Array<DealDay>!
    var foodDealDays: Array<DealDay> = []
    var filteredTableDataSource: Dictionary<Int, Array<DealDay>> = [:]
    var isFiltered: Bool = false
    
    let titleBottomPadding: CGFloat = 15
    let specialBottomPadding: CGFloat = 5
    let infoButtonsHeight: CGFloat = 40
    let infoButtonsTopPadding: CGFloat = 10
    let titleLabelHeight: CGFloat = 30
    let specialHeight: CGFloat = 17
    
    override init() {
        super.init()
        
        fetchData()
    }
    
    func fetchData() {
        APIManger.requestNewData({ (dealDays) -> Void in
            self.unformattedData = dealDays
            self.sortData(dealDays)
            self.delegate?.reloadTable()
        })
        
    }
    
    func sortData(fetchResult: Array<DealDay>) {
        
        var sundayArray: Array<DealDay> = []
        var mondayArray: Array<DealDay> = []
        var tuesdayArray: Array<DealDay> = []
        var wednesdayArray: Array<DealDay> = []
        var thursdayArray: Array<DealDay> = []
        var fridayArray: Array<DealDay> = []
        var saturdayArray: Array<DealDay> = []
        
        for deal in fetchResult {
            
            deal.height = calculateCellHeight(deal, specialCount: deal.specials.count)
            deal.isOpen = NSNumber(bool: false)
            
            switch deal.day.integerValue {
                
            case 1:
                sundayArray.append(deal)
                    break
            case 2:
                mondayArray.append(deal)
                break
            case 3:
                tuesdayArray.append(deal)
                break
            case 4:
                wednesdayArray.append(deal)
                break
            case 5:
                thursdayArray.append(deal)
                break
            case 6:
                fridayArray.append(deal)
                break
            case 7:
                saturdayArray.append(deal)
                break
            default:
                break
            }
        }
        
        if sundayArray.count > 0 {
            if (isFiltered) {
                self.filteredTableDataSource[1] = sundayArray
            } else {
                self.tableDataSource[1] = sundayArray
                originalDataSource[1] = sundayArray
            }
        }
        
        if mondayArray.count > 0 {
            if (isFiltered) {
                self.filteredTableDataSource[2] = mondayArray
            } else {
                self.tableDataSource[2] = mondayArray
                originalDataSource[2] = mondayArray
            }
        }
        
        if tuesdayArray.count > 0 {
            if (isFiltered) {
                self.filteredTableDataSource[3] = tuesdayArray
            } else {
                self.tableDataSource[3] = tuesdayArray
                originalDataSource[3] = tuesdayArray
            }
        }
        
        if wednesdayArray.count > 0 {
            if (isFiltered) {
                self.filteredTableDataSource[4] = wednesdayArray
            } else {
                self.tableDataSource[4] = wednesdayArray
                originalDataSource[4] = wednesdayArray
            }
        }
        
        if thursdayArray.count > 0 {
            if (isFiltered) {
                self.filteredTableDataSource[5] = thursdayArray
            } else {
                self.tableDataSource[5] = thursdayArray
                originalDataSource[5] = thursdayArray
            }
        }
        
        if fridayArray.count > 0 {
            if (isFiltered) {
                self.filteredTableDataSource[6] = fridayArray
            } else {
                self.tableDataSource[6] = fridayArray
                originalDataSource[6] = fridayArray
            }
        }
        
        if saturdayArray.count > 0 {
            if (isFiltered) {
                self.filteredTableDataSource[7] = saturdayArray
            } else {
                self.tableDataSource[7] = saturdayArray
                originalDataSource[7] = saturdayArray
            }
        }
        
        if (isFiltered) {
            self.tableSections = [1,2,3,4,5,6,7]
        } else {
             self.tableSections =  [1,2,3,4,5,6,7]
        }
        
        self.tableSections.sort {
            return $0 < $1
        }
    }
    
    func unscheduleNotification(dealDay: DealDay) {
        
        let application: UIApplication = UIApplication.sharedApplication()
        
        let scheduledNotifications: NSArray = application.scheduledLocalNotifications as NSArray
        
        for notifcation in scheduledNotifications as! [UILocalNotification] {
            
            if (dealDay.notification != nil) && (notifcation.fireDate == dealDay.notification.date) && dealDay.notification.text == notifcation.alertBody {
                
                 application.cancelLocalNotification(notifcation)
                
                let appDelegate: AppDelegate = application.delegate as! AppDelegate
                
                appDelegate.managedObjectContext!.deleteObject(dealDay.notification)
                
                appDelegate.managedObjectContext!.save(nil)
            }
        }
    }
    
    func dayForDayNumber(dayNumber: Int) -> String {
        
        var dayString: String = String()
        
        switch dayNumber {
            case 1:
                dayString = "Sunday"
                break;
            case 2:
                dayString = "Monday"
                break;
            case 3:
                dayString = "Tuesday"
                break;
            case 4:
                dayString = "Wednesday"
                break;
            case 5:
                dayString = "Thursday"
                break;
            case 6:
                dayString = "Friday"
                break;
            case 7:
                dayString = "Saturday"
                break;
            default:
                break;
        }
        
        return dayString
    }
    
    func sortByType(specialType: Int) {
        self.isFiltered = true
        
        var newDealDayArray: Array<DealDay> = []
        
        for (key, value) in self.originalDataSource {
            var j: Int = 0
            
            for dealDay in value {
                
                var i: Int = 0
                
                var currentDealDay: DealDay = self.originalDataSource[key]![j]
                var dealDaySpecials: Array<Special> = Array(currentDealDay.specials) as! Array<Special>
                var hasSpecialOfType: Bool = false;
                
                var newDealDay: DealDay = DealDay()
                
                for special in Array(dealDay.specials) as! Array<Special> {
                    
                    if special.type == specialType {
                        hasSpecialOfType = true;
                    }else {
                        dealDaySpecials.removeAtIndex(i--)

                        let currentHeight: Int = dealDay.height.integerValue
                        
                        var arr: Array<DealDay> = self.originalDataSource[key]!
                        currentDealDay.height = NSNumber(float: Float32(currentHeight - 17))
                    }
                    
                    i++
                }
                
                if hasSpecialOfType {
                    newDealDay.addSpecials(NSSet(array: dealDaySpecials))
                    newDealDay.height = newDealDay.specials.count * 17
                    newDealDay.location = currentDealDay.location
                    newDealDay.type = currentDealDay.type
                    newDealDay.day = currentDealDay.day
                    newDealDayArray.append(newDealDay)
                }
    
                j++
            }
        }
        
        sortData(newDealDayArray)
        
        self.delegate?.reloadTable()
    }
    
    func sortByRating() {
        self.unformattedData = sorted(self.unformattedData) { ($0.location.rating.integerValue as Int) > ($1.location.rating.integerValue as Int) }
    }
    
    func sortAlphabetically() {
        self.unformattedData = sorted(self.unformattedData) { ($0.location.name as String) < ($1.location.name as String) }
    }

    func resetSort() {
        self.sortData(self.unformattedData)
        self.delegate?.reloadTable()
    }
    
    func calculateCellHeight(dealDay: DealDay, specialCount: Int) -> CGFloat {
        let tempLabel: UILabel = UILabel()
        tempLabel.text = dealDay.location.name
        tempLabel.sizeToFit()
        
        let specials = dealDay.specials as NSSet
        
        var cellHeight: CGFloat = tempLabel.height + self.titleBottomPadding + self.infoButtonsTopPadding + (self.specialBottomPadding * CGFloat(specials.count)) + (self.specialHeight * CGFloat(specialCount))
        
        return cellHeight + 24
    }
    
    func getCellHeightForFood(dealDay: DealDay) -> CGFloat {
        var foodCount: Int = 0
        
        for special in Array(dealDay.specials) {
            var spec: Special = special as! Special
            if spec.type == 1 {
                foodCount++
            }
        }
    
        return calculateCellHeight(dealDay, specialCount: foodCount)
    }
    
    func getCellHeightForDrink(dealDay: DealDay) -> CGFloat {
        var drinkCount: Int = 0
        
        for special in Array(dealDay.specials) {
            var spec: Special = special as! Special
            if spec.type == 0 {
                drinkCount++
            }
        }
        
        return calculateCellHeight(dealDay, specialCount: drinkCount)
    }
    
    func checkForNotification(dealDay: DealDay) -> Bool {
        
        var app:UIApplication = UIApplication.sharedApplication()
        
        for oneEvent in app.scheduledLocalNotifications {
            var localNotif = oneEvent as! UILocalNotification
            let userInfoCurrent = localNotif.userInfo!
            let day = userInfoCurrent["day"] as! NSNumber
            let location = userInfoCurrent["location"] as! String
            
            if day == dealDay.day && location == dealDay.location.name {
                return true
            }
        }
        
        return false
    }
    
    
}
