//
//  SearchViewController.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/16/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var viewFrame: CGRect!
    var tableView: UITableView = UITableView()
    var dataSource: Array<Location>!
    var searchBar: UISearchBar = UISearchBar()
    var filteredDataSource: Array<Location>?
    var firstLoad: Bool = true
    
    init(viewFrame: CGRect, locations: Array<Location>) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewFrame = viewFrame
        self.dataSource = locations
        
        self.dataSource = sorted(locations, {
            (loc1: Location, loc2: Location) -> Bool in
            return loc1.name < loc2.name
        })
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view!.frame = CGRectMake(
            0,
            -(self.viewFrame.size.height),
            self.viewFrame.width,
            self.viewFrame.size.height
        )
        
        self.searchBar.placeholder = "Search for a location.."
        self.searchBar.showsCancelButton = true
        self.searchBar.tintColor = .whiteColor()
        self.searchBar.delegate = self
        self.searchBar.layer.cornerRadius = 2.0
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SEARCHCELL")
        self.tableView.layer.cornerRadius = 2.0
        
        self.view!.addSubview(self.searchBar)
        self.view!.addSubview(self.tableView)
    }
    
    override func viewWillLayoutSubviews() {
        self.searchBar.frame = CGRectMake(4, 4, self.view!.width - 8, 40)
        
        self.tableView.frame = CGRectMake(
            4, self.searchBar.bottom + 4,
            self.view!.width - 8,
            self.view!.height - self.searchBar.height
        )
    }
    
    override func viewDidAppear(animated: Bool) {
        if firstLoad {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view!.frame = self.viewFrame
                self.tableView.frame = self.viewFrame
            })
            
            firstLoad = false
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text)
        self.tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.filteredDataSource = nil
        } else {
            filterContentForSearchText(searchBar.text)
        }
        
        if self.filteredDataSource?.count == 0 {
            self.filteredDataSource = nil
        }
        
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredDataSource = self.dataSource.filter({( location: Location) -> Bool in
            let stringMatch = location.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return (stringMatch != nil)
        })
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filteredDataSource = nil
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.filteredDataSource != nil && self.filteredDataSource?.count > 0 {
           return self.filteredDataSource!.count
        } else {
            return self.dataSource.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SEARCHCELL") as? UITableViewCell
   
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SEARCHCELL")
            cell?.textLabel?.font = UIFont(name: "GillSans", size: 16)!
        }
        
        cell?.contentView.tag = 1
        cell?.textLabel?.textColor = UIColor(hexString: "3d3d3e")
        if self.filteredDataSource != nil && self.filteredDataSource?.count > 0 {
            cell?.textLabel?.text = self.filteredDataSource![indexPath.row].name
        } else {
            cell?.textLabel?.text = self.dataSource[indexPath.row].name
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var location: Location!
        
        if self.filteredDataSource != nil {
            location = self.filteredDataSource![indexPath.row]
        } else {
            location = self.dataSource[indexPath.row]
        }
        
        let detailViewController: DetailViewController =
            DetailViewController(location: location, dealDay: nil)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
