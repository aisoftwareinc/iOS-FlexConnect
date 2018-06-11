//
//  DetailsCell.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

protocol DirectionsDelegate: class {
    func didTapDirections()
}

class DetailsCell: UITableViewCell {

    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!

    weak var delegate: DirectionsDelegate?
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
    func configure(_ delivery: Delivery) {
        self.destination.text = delivery.customerName
        self.phoneNumber.text = delivery.customerPhone
        self.address.text = delivery.address
    }
    
 
    @IBAction func directions(_ sender: UIButton) {
        self.delegate?.didTapDirections()
    }
}
