//
//  OrderCell.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var eta: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Colors.background
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    func configureCell(_ order: Delivery) {
        self.destination.text = order.customerName
        self.status.text = order.status
        self.eta.text = order.time
        self.status.textColor = order.status == "Pending" ? Colors.green : Colors.blue
        self.comments.text = order.comments == "" ? "Comments: N/A" : "Comments: \n\(order.comments)"
    }
    
}
