//
//  OrderModel.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

struct OrderModel: Codable {
    let deliveries: [Delivery]
}

struct Delivery: Codable, Equatable {
    let guid, date, time: String
    let customerName, customerEmail, customerPhone, address: String
    let addressCont, city, state, zip: String
    let latitude, longitude, distance, miles: String
    let comments: String
    var status: String
    var enroute: Bool?
    var delivered: Bool?

    enum CodingKeys: String, CodingKey {
        case guid = "GUID"
        case status = "Status"
        case date = "Date"
        case time = "Time"
        case customerName = "CustomerName"
        case customerEmail = "CustomerEmail"
        case customerPhone = "CustomerPhone"
        case address = "Address"
        case addressCont = "AddressCont"
        case city = "City"
        case state = "State"
        case zip = "Zip"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case distance = "Distance"
        case miles = "Miles"
        case comments = "Comments"
    }
    
    mutating func orderIsEnroute(_ bool: Bool) {
        self.enroute = bool
    }
    
    mutating func orderIsDelivered(_ bool: Bool) {
        self.delivered = bool
    }
    
    static func ==(lhs: Delivery, rhs: Delivery) -> Bool {
        if lhs.guid == rhs.guid {
            return true
        }
        return false
    }
}

// MARK: Convenience initializers

extension OrderModel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(OrderModel.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Delivery {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Delivery.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
