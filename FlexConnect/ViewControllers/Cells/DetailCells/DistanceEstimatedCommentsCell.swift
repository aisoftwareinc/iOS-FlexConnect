//
//  DistanceEstimatedCommentsCell.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

class DistanceEstimatedCommentsCell: UITableViewCell {

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
    func configure(_ delivery: Delivery) {
        self.distance.text = delivery.distance
        self.time.text = delivery.time
        self.comments.text = delivery.comments
    }
    
}
