//
//  CameraController.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/30/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

class CameraController: UIViewController {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func capture(_ sender: UIButton) {
    }
}
