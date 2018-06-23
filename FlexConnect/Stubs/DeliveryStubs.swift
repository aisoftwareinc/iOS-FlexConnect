//
//  DeliveryStubs.swift
//  FlexConnect
//
//  Created by Peter Gosling on 6/9/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

struct DeliveryStubs {
    static func deliveries() -> [Delivery] {
     let json =    """
[
    {
        "Address": "1111 S Figueroa St",
        "AddressCont": "",
        "City": "Los Angeles",
        "Comments": "Ask for Jim Bob when you get there.",
        "CustomerEmail": "ed@aisoftware.us",
        "CustomerName": "Staples Center",
        "CustomerPhone": "6026391168",
        "Date": "5/23/2018",
        "Distance": "",
        "GUID": "fc950ce8-2fa3-43fe-ad52-3adb96fcc13c",
        "Latitude": "34.0430058",
        "Longitude": "-118.2673597",
        "Miles": "",
        "State": "CA",
        "Status": "Pending",
        "Time": "By The End of The Day",
        "TimerInterval": "5",
        "Zip": "90015",
        "TimeInterval" : "10"
    },
    {
        "Address": "1111 S Figueroa St",
        "AddressCont": "",
        "City": "Los Angeles",
        "Comments": "Ask for Jim Bob when you get there.",
        "CustomerEmail": "ed@aisoftware.us",
        "CustomerName": "Staples Center",
        "CustomerPhone": "6026391168",
        "Date": "5/23/2018",
        "Distance": "",
        "GUID": "fc950ce8-2fa3-43fe-ad52-3adb96fcc13u",
        "Latitude": "34.0430058",
        "Longitude": "-118.2673597",
        "Miles": "",
        "State": "CA",
        "Status": "Pending",
        "Time": "By The End of The Day",
        "TimerInterval": "5",
        "Zip": "90015",
        "TimeInterval" : "10"
    },
    {
        "Address": "1111 S Figueroa St",
        "AddressCont": "",
        "City": "Los Angeles",
        "Comments": "Ask for Jim Bob when you get there.",
        "CustomerEmail": "ed@aisoftware.us",
        "CustomerName": "Staples Center",
        "CustomerPhone": "6026391168",
        "Date": "5/23/2018",
        "Distance": "",
        "GUID": "fc950ce8-2fa3-43fe-ad52-3adb96fcc13h",
        "Latitude": "34.0430058",
        "Longitude": "-118.2673597",
        "Miles": "",
        "State": "CA",
        "Status": "Pending",
        "Time": "By The End of The Day",
        "TimerInterval": "5",
        "Zip": "90015",
        "TimeInterval" : "10"
    },
    {
        "Address": "1111 S Figueroa St",
        "AddressCont": "",
        "City": "Los Angeles",
        "Comments": "Ask for Jim Bob when you get there.",
        "CustomerEmail": "ed@aisoftware.us",
        "CustomerName": "Staples Center",
        "CustomerPhone": "6026391168",
        "Date": "5/23/2018",
        "Distance": "",
        "GUID": "fc950ce8-2fa3-43fe-ad52-3adb96fcc13s",
        "Latitude": "34.0430058",
        "Longitude": "-118.2673597",
        "Miles": "",
        "State": "CA",
        "Status": "Pending",
        "Time": "By The End of The Day",
        "TimerInterval": "5",
        "Zip": "90015",
        "TimeInterval" : "10"
    },
    {
        "Address": "1111 S Figueroa St",
        "AddressCont": "",
        "City": "Los Angeles",
        "Comments": "Ask for Jim Bob when you get there.",
        "CustomerEmail": "ed@aisoftware.us",
        "CustomerName": "Staples Center",
        "CustomerPhone": "6026391168",
        "Date": "5/23/2018",
        "Distance": "",
        "GUID": "fc950ce8-2fa3-43fe-ad52-3adb96fcc13r",
        "Latitude": "34.0430058",
        "Longitude": "-118.2673597",
        "Miles": "",
        "State": "CA",
        "Status": "Pending",
        "Time": "By The End of The Day",
        "TimerInterval": "5",
        "Zip": "90015",
        "TimeInterval" : "10"
    }
]
"""
        let jsonData = json.data(using: .utf8)!
        let deliveries = try! JSONDecoder().decode([Delivery].self, from: jsonData)
        return deliveries
    }
}
