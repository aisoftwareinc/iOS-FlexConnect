//
//  Collection+Remove.swift
//  FlexConnect
//
//  Created by Peter Gosling on 6/8/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
