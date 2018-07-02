//
//  Display.swift
//  FlexConnect
//
//  Created by Peter Gosling on 7/1/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation
import UIKit

class Display {
    class var width: CGFloat { return UIScreen.main.bounds.size.width }
    class var height: CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength: CGFloat { return max(width, height) }
    class var minLength: CGFloat { return min(width, height) }
    
    class var isSmallDevice: Bool  {
        if maxLength == 568 {
            return true
        }
        return false
    }
}
