//
//  MapFilterTableViewCell.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 5/26/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import UIKit

class MapFilterTableViewCell: UITableViewCell {

    let zoneLabel: UILabel = UILabel()
    let colorView: UIView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        zoneLabel.numberOfLines = 0
        zoneLabel.font = UIFont.systemFontOfSize(12)
        zoneLabel.textAlignment = .Center
        zoneLabel.textColor = .whiteColor()
        
        self.addSubview(zoneLabel)
        self.addSubview(colorView)
    }
    
    func configure(cellWidth: CGFloat, data: Dictionary<String, String>) {
        
        let zonetext: NSString =  NSString(string: data["zone"]!)
        
        let labelSize: CGSize = zonetext.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
        
        zoneLabel.frame = CGRectMake(0, self.height / 2 - labelSize.height / 2, cellWidth, labelSize.height)
        
        zoneLabel.text = zonetext as String
        
        self.backgroundColor = UIColor(hexString: data["color"]!)
    }
    
    override func layoutSubviews() {
        let height: CGFloat = 10
        let width: CGFloat = self.width
        
        colorView.frame = CGRectMake(
            self.width / 2 - width / 2,
            self.height - height,
            width,
            height
        )
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError("init(coder:) has not been implemented")
    }

}
