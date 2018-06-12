//
//  Networking.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure
}

class Networking {
    static func send<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T>) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else {
                    completion(.failure)
                    return
                }
                let object = try! JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(object)) }
                return
            }
            print("Error: \(String.init(data: data!, encoding: .utf8) ?? "")")
            completion(.failure)
        }
        dataTask.resume()
    }
}


