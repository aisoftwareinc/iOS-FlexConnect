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
    @IBOutlet weak var phoneNumber: UITextView!
    @IBOutlet weak var address: UILabel!

    weak var delegate: DirectionsDelegate?
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.background
        self.phoneNumber.backgroundColor = Colors.background
        self.phoneNumber.isEditable = false
        self.phoneNumber.dataDetectorTypes = .phoneNumber
    }
    
    func configure(_ delivery: Delivery) {
        self.destination.text = delivery.customerName
        self.phoneNumber.text = Utilities.format(phoneNumber: delivery.customerPhone)
        self.address.text = delivery.address
    }
    
 
    @IBAction func directions(_ sender: UIButton) {
        self.delegate?.didTapDirections()
    }
}
