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
    func reset(_ controller: LoginViewController)
}

enum LoginState {
    case requestToken(String)
    case authorizeToken(String)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var entryField: UITextField!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
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
        self.entryField.layer.cornerRadius = 3.0
        self.entryField.layer.borderWidth = 1.0
        self.entryField.layer.borderColor = UIColor.darkGray.cgColor
        self.resetButton.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Colors.background
    }
    
    func setState(_ state: LoginState) {
        self.loginState = state
        switch self.loginState {
        case .requestToken:
            self.entryField.text = ""
            self.entryField.placeholder = "Phone Number"
            self.actionButton.setTitle("Request Token", for: .normal)
            self.resetButton.isHidden = true
        case .authorizeToken:
            self.entryField.text = ""
            self.entryField.placeholder = "Token"
            self.actionButton.setTitle("Verify Token", for: .normal)
            self.resetButton.isHidden = false
        }
    }
    

    @IBAction func resetLogin(_ sender: UIButton) {
        self.delegate?.reset(self)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        switch self.loginState {
        case .requestToken:
            guard let enteredNumber = self.entryField.text else {
                return
            }
            self.delegate?.didClickAction(self, .requestToken(enteredNumber))
        case .authorizeToken:
            guard let enteredToken = self.entryField.text else {
                return
            }
            self.delegate?.didClickAction(self, .authorizeToken(enteredToken))
        }
    }
}
