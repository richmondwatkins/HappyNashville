//
//  LocationSpecialViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/18/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class LocationSpecialViewController: UIViewController {

    var index: Int = Int()
    var dealDay: DealDay?
    var viewModel:LocationSpecialViewModel = LocationSpecialViewModel()
    
    init(dealDay: DealDay) {
        super.init(nibName: nil, bundle: nil)
        
        self.dealDay = dealDay
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var top: CGFloat = 0

        for special in self.viewModel.sortSpecialsByTime(self.dealDay!.specials) as! [Special] {
            
            let specialView: LocationSpecialView = LocationSpecialView(special: special, frame: CGRectMake(0, 0, self.view!.width, 0))
            
            self.view!.addSubview(specialView)
            
            specialView.top = top
            
            top = specialView.bottom + 2
        }
    }

}
