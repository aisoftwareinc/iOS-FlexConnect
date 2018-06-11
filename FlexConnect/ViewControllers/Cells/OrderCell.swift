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
    @IBOutlet weak var urgency: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ order: Delivery) {
        self.destination.text = order.customerName
        self.address.text = order.address
        self.status.text = order.status
        self.eta.text = order.time
        self.urgency.text = order.status
        self.distance.text = order.miles
    }
    
}
