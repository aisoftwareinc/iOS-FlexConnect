//
//  LocationManager.swift
//  LocationTracker
//
//  Created by Peter Gosling on 7/26/17.
//  Copyright © 2017 Peter Gosling. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var timeInterval: Double = 10000.0
    var isUpdating: Bool = false
    var didSendInitial: Bool = false
    
    private var timer : Timer!
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func start() {
        if !self.isUpdating {
        self.locationManager.startMonitoringSignificantLocationChanges()
            self.isUpdating = true
            self.timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: true, block: { (Timer) in
                self.sendLocation()
            })
        }
    }
    
    func sendLocation() {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        let locationRequest = Requests.reportLocationPostRequest(String(currentLocation.coordinate.latitude), String(currentLocation.coordinate.longitude))
        Networking.send(locationRequest, completion: { (result: Result<Success>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure:
                print("Failure")
            }
        })
    }
    
    func stop() {
        if self.isUpdating {
            self.locationManager.stopUpdatingLocation()
            self.isUpdating = false
            self.didSendInitial = false
            self.timeInterval = 10000.0
            self.timer.invalidate()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
        if self.didSendInitial == false {
            self.sendLocation()
            self.didSendInitial = true
        }
    }
}

