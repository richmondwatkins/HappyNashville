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
    
    init(isFoodSort: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        if isFoodSort {
            self.sortValue = 1
        } else {
            self.sortValue = 0
        }
    }

    required init(coder aDecoder: NSCoder) {
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
        
        var dealDay: DealDay = getDealDayForIndexPath(indexPath)!
        
        return self.viewModel.getCellHeightForFood(dealDay)
    }
    
    override func scrollToCurrentDay() {
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
    }
    
    
    override func addSpecialsToCell(cell: LocationTableViewCell, dealDay: DealDay) {
        var top: CGFloat = cell.ratingView.bottom + 5
        
        var newSpecialCount: Int = Int()
        
        for special in self.viewModel.sortSpecialsByTime(dealDay.specials) as! [Special] {
            if special.type.integerValue == self.sortValue {
                let specialView: SpecialView = SpecialView(special: special, frame: CGRectMake(10, top, self.view!.width - 10, self.specialHeight))
                
                cell.contentCard.addSubview(specialView)
                
                specialView.top = top
                
                top = specialView.bottom + specialBottomPadding
                
                specialView.tag = 1
                
                newSpecialCount += 1
            }
        }

    }

}
