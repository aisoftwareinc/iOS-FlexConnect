//
//  TokenHelper.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/13/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

enum TokenHelperState: Error {
    case numberFail
    case tokenFail
}

struct TokenHelper {
    static var token: String = "TOKEN"
    static var phoneNumber: String = "PHONE"
    
    static func saveNumber(_ phoneNumber: String) {
        UserDefaults.standard.setValue(phoneNumber, forKey: TokenHelper.phoneNumber)
    }
    
    static func fetchNumber() throws -> String {
        guard let number = UserDefaults.standard.value(forKey: TokenHelper.phoneNumber) as? String else {
            throw TokenHelperState.numberFail
        }
        return number
    }
    
    static func removeNumber() {
        UserDefaults.standard.removeObject(forKey: TokenHelper.phoneNumber)
    }
}
