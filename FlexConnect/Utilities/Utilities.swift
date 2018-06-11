//
//  Utilities.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/23/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    static func showAlert(_ errorText: String) -> UIAlertController {
        let alertController = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
}
