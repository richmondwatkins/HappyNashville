//
//  FoodDrinkViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/23/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class FoodDrinkViewController: ViewController {
    
    var sortValue: Int = Int()
    
    var foodDataSource: Dictionary<Int, Array<DealDay>> = [:]
    
    init(isFoodSort: Bool, tableDataSource: Dictionary<Int, Array<DealDay>>) {
        super.init(nibName: nil, bundle: nil)
        
//        if isFoodSort {
//            self.sortValue = 1
//        } else {
//            self.sortValue = 0
//        }
//        
        self.foodDataSource = tableDataSource;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.top = self.navigationController!.navigationBar.bottom
        
        self.tableView.height -= self.navigationController!.navigationBar.bottom
        
        self.tableView.reloadData()
    }

    override func getCellHeight(dealDay: DealDay) -> CGFloat {
        
        if sortValue == 1 {
             return self.viewModel.getCellHeightForFood(dealDay)
        }
       
         return self.viewModel.getCellHeightForDrink(dealDay)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let dealDay: DealDay = getDealDayForIndexPath(indexPath)!
        
        return CGFloat(dealDay.height.floatValue)
    }
    
    override func scrollToCurrentDay() {
        
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionDay: Int = self.viewModel.tableSections[section]
        
        return  self.foodDataSource[sectionDay]!.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.viewModel.tableSections.count
        
    }
    
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let view: UIView = UIView(frame: CGRectMake(0, 0, self.view!.width, 20))
    //
    //        view.backgroundColor = .clearColor()
    //
    //        return view
    //    }
    
    
//    
//    override func addSpecialsToCell(cell: LocationTableViewCell, dealDay: DealDay) {
//        var top: CGFloat = cell.ratingView.bottom + 5
//        
//        var newSpecialCount: Int = Int()
//        
//        for special in self.viewModel.sortSpecialsByTime(dealDay.specials) as! [Special] {
//            if special.type.integerValue == self.sortValue {
//                let specialView: SpecialView = SpecialView(special: special, frame: CGRectMake(10, top, self.view!.width - 10, self.specialHeight))
//                
//                cell.contentCard.addSubview(specialView)
//                
//                specialView.top = top
//                
//                top = specialView.bottom + specialBottomPadding
//                
//                specialView.tag = 1
//                
//                newSpecialCount += 1
//            }
//        }
//
//    }

}
