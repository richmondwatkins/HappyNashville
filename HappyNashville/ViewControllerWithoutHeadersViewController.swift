//
//  ViewControllerWithoutHeadersViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/20/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class ViewControllerWithoutHeadersViewController: ViewController {
    
    var tableData: Array<DealDay>!
    
    init(tableData: Array<DealDay>) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableData = tableData
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
    
    override func scrollToCurrentDay() {
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? LocationTableViewCell
        
        if cell == nil {
            
            cell = LocationTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        } 
        
        configureCell(cell!, dealDay: self.tableData[indexPath.row])
        
        return cell!
    }
    
    override func getDealDayForIndexPath(indexPath: NSIndexPath) -> DealDay {

        return self.tableData[indexPath.row]
    }

}
