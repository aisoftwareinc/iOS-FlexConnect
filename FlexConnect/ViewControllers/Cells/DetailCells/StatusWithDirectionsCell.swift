//
//  StatusWithDirectionsCell.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

protocol StatusCellProtocol: class {
    func didSwitchEnroute(_ bool: Bool)
    func didSwitchDelivered()
    func attachPhoto()
}

class StatusWithDirectionsCell: UITableViewCell {

    @IBOutlet weak var enRouteSwitch: UISwitch!

    
    weak var delegate: StatusCellProtocol?
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }

    func configure(_ status: CDDeliveryStatus) {
        self.enRouteSwitch.isOn = status.enroute
    }
    
    @IBAction func enRoute(_ sender: UISwitch) {
        self.delegate?.didSwitchEnroute(sender.isOn)
    }

    @IBAction func delivered(_ sender: UIButton) {
        self.delegate?.didSwitchDelivered()
    }
    
    @IBAction func getAttachPhoto(_ sender: UIButton) {
        self.delegate?.attachPhoto()
    }
}
