//
//  URLs.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/21/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

struct URLs {
    static let authCode = "https://portal.flexconnect.us/ws/tracking-json.asmx/AuthenticatePhone"
    static let deliveryURL = "https://portal.flexconnect.us/ws/tracking-json.asmx/GetDeliveries"
    static let locationURL = "https://portal.flexconnect.us/ws/tracking-json.asmx/ReportLocation"
    static let intervalURL = "https://portal.flexconnect.us/ws/tracking-json.asmx/TimerInterval"
    static let statusURL = "https://portal.flexconnect.us/ws/tracking-json.asmx/UpdateStatus"
}
