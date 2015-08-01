//
//  ViewControllerViewModel.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 3/31/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

@objc protocol ViewModelProtocol {
    func reloadTable()
    func refreshTable()
    func activateView()
}

 class ViewControllerViewModel: AppViewModel, CLLocationManagerDelegate {
    
    var tableDataSource: Dictionary<Int, Array<DealDay>> {
        get {
            if isFiltered {
                return self.filteredTableDataSource
            } else {
                return self.originalDataSource
            }
        }
        set {
            
        }
    }
    var originalDataSource: Dictionary<Int, Array<DealDay>> = [:]
    var delegate: ViewModelProtocol?
    var tableSections: Array<Int> = []
    var unformattedData: Array<DealDay> = []
    var foodDealDays: Array<DealDay> = []
    var filteredTableDataSource: Dictionary<Int, Array<DealDay>> = [:]
    var isFiltered: Bool = false
    var locations: Array<Location> = []
    var shouldSort: Bool = false
    
    let locationManager = CLLocationManager()
    let titleBottomPadding: CGFloat = 15
    let specialBottomPadding: CGFloat = 5
    let infoButtonsHeight: CGFloat = 40
    let infoButtonsTopPadding: CGFloat = 10
    let titleLabelHeight: CGFloat = 30
    let specialHeight: CGFloat = 18
    
    override init() {
        super.init()

        fetchData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFromNotif", name:"UpdatedData", object: nil)
    }
    
    func updateFromNotif() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UpdatedData", object: nil)

        fetchData(false);
    }
    
    func fetchData(shouldScrollToIndex: Bool? = true) {
        APIManger.requestNewData({ (dealDays, locations) -> Void in
 
            self.locations = locations
            self.unformattedData = dealDays
            
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
                self.requestUserLocation()
            }
            
            let sortedByDistanceDealDay = dealDays.sort({
                (deal1: DealDay, deal2: DealDay) -> Bool in
                return self.getEaliestSpecial(deal1.specials).hourStart.integerValue < self.getEaliestSpecial(deal2.specials).hourStart.integerValue
            })
            
            self.sortData(sortedByDistanceDealDay)

            if (shouldScrollToIndex == true) {
                self.delegate?.reloadTable()
            } else {
                self.delegate?.refreshTable()
            }
            
            self.delegate?.activateView()
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
        
        self.tableSections =  [1,2,3,4,5,6,7]
        
        self.tableSections.sortInPlace {
            return $0 < $1
        }
    }
    
    func unscheduleNotification(dealDay: DealDay) {
        
        let app: UIApplication = UIApplication.sharedApplication()
        
        for oneEvent in app.scheduledLocalNotifications! {
            let userInfoCurrent = oneEvent.userInfo!
            let day = userInfoCurrent["day"] as! NSNumber
            let location = userInfoCurrent["location"] as! String
            
            if day == dealDay.day && location == dealDay.location.name {
                app.cancelLocalNotification(oneEvent)
                APIManger.deleteNotificationFromID(userInfoCurrent["notifId"] as! String)
            }
        }
    }
    
    func sortByType(specialType: Int) {

        self.isFiltered = true
        
        var newDealDayArray: Array<DealDay> = []
        
        for (key, value) in self.originalDataSource {
            var j: Int = 0
            
            for dealDay in value {
                
                var i: Int = 0
                
                let currentDealDay: DealDay = self.originalDataSource[key]![j]
                var dealDaySpecials: Array<Special> = Array(currentDealDay.specials) as! Array<Special>
                var hasSpecialOfType: Bool = false;
                
                let newDealDay: DealDay = DealDay()
                
                for special in Array(dealDay.specials) as! Array<Special> {
                    
                    if specialType == 6 {
                        if special.type == specialType {
                            hasSpecialOfType = true;
                        }else {
                            dealDaySpecials.removeAtIndex(i--)
                            
                            let currentHeight: Int = dealDay.height.integerValue
                            
                            currentDealDay.height = NSNumber(float: Float32(currentHeight - 17))
                        }
                    } else {
                        if special.type != 6 {
                            hasSpecialOfType = true;
                        }else {
                            dealDaySpecials.removeAtIndex(i--)
                            
                            let currentHeight: Int = dealDay.height.integerValue
                            
                            currentDealDay.height = NSNumber(float: Float32(currentHeight - 17))
                        }
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

    func requestUserLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            
            self.locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse){
            
            locationManager.startUpdatingLocation()
        } else {
            //
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        self.locationManager.stopUpdatingLocation()
        
        addDistanceToLocations(coord)
    }
    
    func addDistanceToLocations(coords: CLLocationCoordinate2D) {
        for location in locations {
            let newCoord: CLLocation = CLLocation(latitude: location.lat.doubleValue, longitude: location.lng.doubleValue)
            
            location.distanceFromUser = newCoord.distanceFromLocation(CLLocation(latitude: coords.latitude, longitude: coords.longitude)) /  1609.344
        }
        
        if (self.shouldSort) {
            sortByVicinity(coords)
        } else {
            self.delegate?.reloadTable()
        }
    }
    
    func sortByVicinity(coords: CLLocationCoordinate2D) {
        
        let sortedByDistanceDealDay = self.unformattedData.sort({
            (str1: DealDay, str2: DealDay) -> Bool in
            return str1.location.distanceFromUser.doubleValue < str2.location.distanceFromUser.doubleValue
        })
        
        sortData(sortedByDistanceDealDay)
        
        self.delegate?.reloadTable()
        
        self.shouldSort = false
    }
    
    func sortByRating() {
        self.unformattedData = self.unformattedData.sort { ($0.location.rating.integerValue as Int) > ($1.location.rating.integerValue as Int) }
    }
    
    func sortAlphabetically() {
        self.unformattedData = self.unformattedData.sort { ($0.location.name as String) < ($1.location.name as String) }
    }

    func resetSort() {
        self.sortData(self.unformattedData)
        self.delegate?.reloadTable()
    }
    
    func calculateCellHeight(dealDay: DealDay, specialCount: Int) -> CGFloat {
        let specials = dealDay.specials as NSSet
        
        let cellHeight: CGFloat = 16 + self.titleBottomPadding + self.infoButtonsTopPadding + (self.specialBottomPadding * CGFloat(specials.count)) + (self.specialHeight * CGFloat(specialCount))
        
        return cellHeight + 30
    }
    
    func getCellHeightForFood(dealDay: DealDay) -> CGFloat {
        var foodCount: Int = 0
        
        for special in Array(dealDay.specials) {
            let spec: Special = special as! Special
            if spec.type == 1 {
                foodCount++
            }
        }
    
        return calculateCellHeight(dealDay, specialCount: foodCount)
    }
    
    func getCellHeightForDrink(dealDay: DealDay) -> CGFloat {
        var drinkCount: Int = 0
        
        for special in Array(dealDay.specials) {
            let spec: Special = special as! Special
            if spec.type == 0 {
                drinkCount++
            }
        }
        
        return calculateCellHeight(dealDay, specialCount: drinkCount)
    }
    
    func checkForNotification(dealDay: DealDay) -> Bool {
        
        let app:UIApplication = UIApplication.sharedApplication()
        
        for oneEvent in app.scheduledLocalNotifications! {
            let localNotif = oneEvent
            let userInfoCurrent = localNotif.userInfo!
            let day = userInfoCurrent["day"] as! NSNumber
            let location = userInfoCurrent["location"] as! String
            
            if day == dealDay.day && location == dealDay.location.name {
                
                return true
            }
        }
        
        return false
    }
    
    func returnLocationFromName(name: String) -> Location? {
        
        for location in self.locations {
            if location.name == name {
                return location
            }
        }
        
        return nil
    }
    
}
