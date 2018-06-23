//
//  AppDescriptionCell.swift
//  FlexConnect
//
//  Created by Peter Gosling on 6/9/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

class AppDescriptionCell: UITableViewCell {
    @IBOutlet weak var cellDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Colors.background
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
}
