//
//  LoginViewController.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/12/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit
import GoogleMaps

protocol LoginControllerProtocol: class {
    func didClickAction(_ controller: LoginViewController, _ state: LoginState)
}

enum LoginState {
    case requestToken(String)
    case authorizeToken(String)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    weak var delegate: LoginControllerProtocol?
    var loginState: LoginState = .requestToken("")
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("die")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setState(_ state: LoginState) {
        self.loginState = state
        switch self.loginState {
        case .requestToken:
            self.phoneNumber.text = ""
            self.phoneNumber.placeholder = "Phone Number"
            self.actionButton.setTitle("Request Token", for: .normal)
        case .authorizeToken:
            self.phoneNumber.text = ""
            self.phoneNumber.placeholder = "Token"
            self.actionButton.setTitle("Verify Token", for: .normal)
        }
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        switch self.loginState {
        case .requestToken:
            guard let enteredNumber = self.phoneNumber.text else {
                return
            }
            self.delegate?.didClickAction(self, .requestToken(enteredNumber))
        case .authorizeToken:
            guard let enteredToken = self.phoneNumber.text else {
                return
            }
            self.delegate?.didClickAction(self, .authorizeToken(enteredToken))
        }
    }
}
