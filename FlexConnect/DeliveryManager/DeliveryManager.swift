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
        Networking.send(Requests.fetchDeliveries()) { (result: Result<OrderModel>) in
            switch result {
            case .success(let order):
                
                order.deliveries.forEach({
                    CoreData.shared.saveDelivery($0.guid)
                    let state = $0.status == "Pending" ? false : true
                    CoreData.shared.setEnroute($0.guid, state)
                })
                
                self.deliveries = order.deliveries
                
                DispatchQueue.main.async { completion(self.deliveries) }
                
                if self.enrouteDeliveries() > 0 {
                    LocationManager.shared.start()
                }

                
//                let stubs = DeliveryStubs.deliveries()
//                stubs.forEach({ CoreData.shared.saveDelivery($0.guid) })
//                self.deliveries = stubs
//                completion(self.deliveries)
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
        enrouteDelivery.status = state ? "En Route" : "Pending"
        if let index = self.deliveries.index(of: delivery) {
            self.deliveries[index] = enrouteDelivery
        }
    }
    
    func enrouteDeliveries() -> Int {
        return self.deliveries.filter({ $0.status == "En Route" }).count
    }
}
