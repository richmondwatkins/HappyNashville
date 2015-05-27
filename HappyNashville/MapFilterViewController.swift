//
//  MapFilterViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/25/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

@objc protocol MapFilterProtocol {
    func closeSidemenu()
    func filterTwelveSouth()
    func filterDowntown()
    func filterGermantown()
    func filterEastNashville()
    func filterGulch()
    func filterHillsboro()
    func filterMidtown()
    func resetAll()
}

class MapFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView = UITableView()
    var viewFrame: CGRect!
    var delegate: MapFilterProtocol?
    var dataSource: Array<Dictionary<String, String>> = [
        ["zone": "Twelve \n South", "color": StringConstants.twelveSouthColor, "isSelected": "1"],
        ["zone": "Downtown", "color": StringConstants.downtownColor, "isSelected": "1"],
        ["zone": "East \n Nashville", "color": StringConstants.eastNashColor, "isSelected": "1"],
        ["zone": "German \n Town", "color": StringConstants.germanTownColor, "isSelected": "1"],
        ["zone": "The \n Gulch", "color": StringConstants.gulchColor, "isSelected": "1"],
        ["zone": "Hillsboro \n Village", "color": StringConstants.hillsboroColor, "isSelected": "1"],
        ["zone": "Midtown", "color": StringConstants.midtownColor, "isSelected": "1"],
        ["zone": "Reset", "color": "000000", "isSelected": "1"]
    ]
    
    init(viewFrame: CGRect) {
        self.viewFrame = viewFrame
        
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MAPFILTERCELL")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor(hexString: StringConstants.grayShade)
        
        self.tableView.frame = self.viewFrame
        self.view.frame = self.viewFrame
        
        self.view!.addSubview(tableView)
        
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.view.frame = viewFrame
        
        tableView.frame = CGRectMake(
            0,
            0,
            self.view.width,
            self.view.height
        )
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MAPFILTERCELL") as? MapFilterTableViewCell
        
        if cell == nil {
            
            cell = MapFilterTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "MAPFILTERCELL")
        }
        
        cell?.configure(self.view.width, data: self.dataSource[indexPath.row])
                
        return cell!
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let isFiltered: String = dataSource[indexPath.row]["isSelected"]! == "1" ? "0" : "1"
            
        self.dataSource[indexPath.row] = [
            "zone": dataSource[indexPath.row]["zone"]!,
            "color": dataSource[indexPath.row]["color"]!,
            "isSelected": isFiltered
        ];
        
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)

        switch indexPath.row {
            case 0:
                self.delegate?.filterTwelveSouth()
                break;
            case 1:
                self.delegate?.filterDowntown()
                break;
            case 2:
                self.delegate?.filterEastNashville()
                break;
            case 3:
                self.delegate?.filterGermantown()
                break;
            case 4:
                self.delegate?.filterGulch()
                break;
            case 5:
                 self.delegate?.filterHillsboro()
                break;
            case 6:
                self.delegate?.filterMidtown()
                break;
            case 7:
                resetMap()
                break;
            default:
                break;
        }
    }
    
    func resetMap() {
        for var i = 0; i < self.dataSource.count; i++ {
            self.dataSource[i] = [
                "zone": dataSource[i]["zone"]!,
                "color": dataSource[i]["color"]!,
                "isSelected": "1"
            ];
        }
        self.tableView.reloadData()
        self.delegate?.resetAll()
    }
}
