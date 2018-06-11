//
//  CoreData.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/26/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreData {
    static let shared = CoreData()
    var context : NSManagedObjectContext!
    var mainContext : NSManagedObjectContext!
    
    private init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        self.mainContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.context.automaticallyMergesChangesFromParent = true
    }
    
    func saveDelivery(_ guid: String) {
        if let _ = self.fetchDelivery(guid) {
            return
        }
        
        let deliveryStatus = NSEntityDescription.insertNewObject(forEntityName: "CDDeliveryStatus", into: self.context) as! CDDeliveryStatus
        deliveryStatus.guid = guid
    }
    
    func fetchDelivery(_ guid: String) -> CDDeliveryStatus? {
        do {
            let savedDeliveries = try self.context.fetch(CDDeliveryStatus.fetchRequest()) as! [CDDeliveryStatus]
            let delivery = savedDeliveries.filter({ $0.guid == guid }).first
            return delivery
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func setEnroute(_ guid: String, _ bool: Bool) {
        if let delivery = self.fetchDelivery(guid) {
            delivery.enroute = bool
        }
    }
}
