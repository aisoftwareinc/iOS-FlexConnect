//
//  Requests.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/21/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

class Requests {
    static func authCode(_ phoneNumber: String) -> URLRequest {
        var components = URLComponents.init(string: URLs.authCode)!
        let phoneItem = URLQueryItem.init(name: "Phone", value: phoneNumber)
        let apiKeyItem = URLQueryItem.init(name: "APIKey", value: Keys.apiKey)
        components.queryItems = [phoneItem, apiKeyItem]
        return URLRequest.init(url: components.url!)
    }
    
    static func fetchDeliveries() -> URLRequest {
        var components = URLComponents.init(string: URLs.deliveryURL)!
        let phoneItem = URLQueryItem.init(name: "Phone", value: try? TokenHelper.fetchNumber())
        let apiKeyItem = URLQueryItem.init(name: "APIKey", value: Keys.apiKey)
        components.queryItems = [phoneItem, apiKeyItem]
        return URLRequest.init(url: components.url!)
    }
    
    static func reportLocationPostRequest(_ latitutde: String, _ longitude: String) -> URLRequest {
        var components = URLComponents.init(string: URLs.locationURL)!
        let phoneItem = URLQueryItem.init(name: "Phone", value: try? TokenHelper.fetchNumber())
        let apiKeyItem = URLQueryItem.init(name: "APIKey", value: Keys.apiKey)
        let latitudeItem = URLQueryItem.init(name: "Latitude", value: latitutde)
        let longitudeItem = URLQueryItem.init(name: "Longitude", value: longitude)
        let userAgentItem = URLQueryItem.init(name: "UserAgent", value: "iOS")
        components.queryItems = [phoneItem, latitudeItem, longitudeItem, userAgentItem, apiKeyItem]
        return URLRequest.init(url: components.url!)
    }
    
    static func status(_ status: String, _ guid: String, base64Image: String, comments: String) -> URLRequest {
        
        let url = URLs.statusURL
        var urlRequest = URLRequest.init(url: URL.init(string: url)!)
        
        guard let phoneNumber = try? TokenHelper.fetchNumber() else {
            fatalError("Can't convert delivered URL. Phone number fetch failed")
        }
        
       let data = "Phone=\(phoneNumber)&Status=\(status)&Photo=\(base64Image)&Comments=\(comments)&GUID=\(guid)&APIKey=\(Keys.apiKey)"
        
        let dataString = data.data(using: .utf8, allowLossyConversion: false)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = dataString
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("\(dataString!.count)", forHTTPHeaderField: "content-length")
        return urlRequest
    }
    
    static func timeInterval() -> URLRequest {
        var components = URLComponents.init(string: URLs.intervalURL)!
        let apiKeyItem = URLQueryItem.init(name: "APIKey", value: Keys.apiKey)
        components.queryItems = [apiKeyItem]
        return URLRequest.init(url: components.url!)
    }
    
    static func fetchDirections(_ directionsURL: String) -> URLRequest {
        let urlReuqest = URLRequest.init(url: URL(string: directionsURL)!)
        return urlReuqest
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        return allowed
    }()
}
