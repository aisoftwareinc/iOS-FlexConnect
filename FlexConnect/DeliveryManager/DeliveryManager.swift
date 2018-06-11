//
//  Orders.swift
//  FlexConnect
//
//  Created by Peter Gosling on 6/8/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation

protocol DeliveryDelegate: class {
    func didFetchDelivery()
}

class DeliveryManager {
    
    private var deliveries = [Delivery]()
    
    func fetchDeliveries(_ completion: @escaping (([Delivery]?) -> ())) {
        Networking.fetch(Requests.fetchDeliveries()) { (result: Result<OrderModel>) in
            switch result {
            case .success(let order):
                
//                order.deliveries.forEach({ CoreData.shared.saveDelivery($0.guid) })
//                self.deliveries = order.deliveries
//                completion(self.deliveries)
//
                
                let stubs = DeliveryStubs.deliveries()
                stubs.forEach({ CoreData.shared.saveDelivery($0.guid) })
                self.deliveries = stubs
                completion(self.deliveries)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func removeDelivery(_ delivery: Delivery) {
        self.deliveries.remove(object: delivery)
    }
    
    func currentDeliveries() -> [Delivery] {
        return self.deliveries
    }
    
    func deliveryEnroute(_ delivery: Delivery, state: Bool) {
        var enrouteDelivery = delivery
        enrouteDelivery.status = state ? "En route" : "Pending"
        if let index = self.deliveries.index(of: delivery) {
            self.deliveries[index] = enrouteDelivery
        }
    }
}
