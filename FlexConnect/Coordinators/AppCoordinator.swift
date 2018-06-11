//
//  MainCoordinator.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/12/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import Foundation
import UIKit
import os
import CoreLocation
import MapKit

class AppCoordinator: NSObject {
    private(set) var authToken: String?
    private let deliveryManager = DeliveryManager()
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    let window: UIWindow
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = false
        return navigationController
    }()
    
    public init(window: UIWindow) {
        self.window = window
        super.init()
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        guard let _ = try? TokenHelper.fetchNumber() else {
            self.showLogin()
            return
        }
        self.fetchTimeInterval()
        self.fetchOrders()
    }
    
    private func showLogin() {
        let loginController = LoginViewController.init()
        loginController.delegate = self
        loginController.title = "FlexConnect"
        self.navigationController.viewControllers = [loginController]
    }
    
    func fetchOrders() {
        
        let orderController = OrderViewController.init(nibName: nil, bundle: nil)
        orderController.title = "Orders"
        orderController.delegate = self
        self.navigationController.viewControllers = [orderController]
        
        self.deliveryManager.fetchDeliveries { (deliveries) in
            guard let deliveries = deliveries else {
                print("Failed to fetch deliveries.")
                self.navigationController.present(Utilities.showAlert("No deliveries found for this number."), animated: true, completion: nil)
                return
            }
            
            if deliveries.count == 0 {
                self.navigationController.present(Utilities.showAlert("No deliveries found for this number."), animated: true, completion: nil)
            }
            /*For release use `deliveries` instead of stubs*/
            orderController.refresh(deliveries)
        }
    }
    
    func fetchTimeInterval() {
        Networking.fetch(Requests.timeInterval()) { (result: Result<TimeInterval>) in
            switch result {
            case .success(let timeInterval):
                LocationManager.shared.timeInterval = Double(timeInterval.duration) ?? 300.0
            case .failure:
                print("Failed to fetch time interval.")
            }
        }
    }
}

// MARK: Login Delegate

extension AppCoordinator: LoginControllerProtocol {
    func didClickAction(_ controller: LoginViewController, _ state: LoginState) {
        switch state {
        case .authorizeToken(let enteredToken):
            if self.authToken == enteredToken {
                Networking.fetch(Requests.fetchDeliveries()) { (result: Result<OrderModel>) in
                    switch result {
                    case .success(let orders):
                        print(orders)
                        let orderController = OrderViewController.init(orders.deliveries)
                        orderController.title = "Orders"
                        orderController.delegate = self
                        self.navigationController.pushViewController(orderController, animated: true)
                    case .failure:
                        print("Failed to fetch deliveries")
                    }
                }
            } else {
                self.navigationController.present(Utilities.showAlert("Incorrect token entered."), animated: true, completion: nil)
                controller.setState(.requestToken(""))
            }
        case .requestToken(let phoneNumber):
            Networking.fetch(Requests.authCode(phoneNumber)) { (result: Result<AuthCode>) in
                switch result {
                case .success(let authCode):
                    TokenHelper.saveNumber(phoneNumber)
                    self.authToken = authCode.authCode
                    controller.setState(.authorizeToken(authCode.authCode))
                case .failure:
                    controller.setState(.requestToken(""))
                }
            }
        }
    }
}

extension AppCoordinator: OrderControllerProtocol {
    func didTapOrder(_ order: Delivery) {
        let details = OrderDetailsViewController.init(order)
        details.delegate = self
        self.navigationController.pushViewController(details, animated: true)
    }
    
    func updateDeliveries() -> [Delivery] {
        return self.deliveryManager.currentDeliveries()
    }
    
    func checkForNewDeliveries(for orderController: OrderViewController) {
        orderController.refreshControl.beginRefreshing()
        self.deliveryManager.fetchDeliveries { (deliveries) in
            orderController.refreshControl.endRefreshing()
            guard let deliveries = deliveries else {
                print("Failed to fetch deliveries.")
                self.navigationController.present(Utilities.showAlert("No deliveries found for this number."), animated: true, completion: nil)
                return
            }
            
            if deliveries.count == 0 {
                self.navigationController.present(Utilities.showAlert("No deliveries found for this number."), animated: true, completion: nil)
            }
            /*For release use `deliveries` instead of stubs*/
            orderController.refresh(deliveries)
        }
    }
}

extension AppCoordinator: OrderDetailsDelegate {
    func userDidTapEnroute(_ bool: Bool, _ delivery: Delivery) {
        bool ? LocationManager.shared.start() : LocationManager.shared.stop()
        self.deliveryManager.deliveryEnroute(delivery, state: bool)
        Networking.fetch(Requests.status("2", delivery.guid, base64Image: "", comments: "")) { (result: Result<Success>) in
            switch result {
            case .success:
                CoreData.shared.setEnroute(delivery.guid, bool)
                print("Package enroute...")
                break
            case .failure:
                break
            }
        }
    }
    
    func userDidTapDelivered(_ delivery: Delivery, _ guid: String, photoStringBase64: String, comments: String) {
        Networking.fetch(Requests.status("3", guid, base64Image: photoStringBase64, comments: comments)) { (result: Result<Success>) in
            switch result {
            case .success:
                self.deliveryManager.removeDelivery(delivery)
                self.navigationController.popViewController(animated: true)
                print("Success photo attachment.")
            case .failure:
                print("Failed deilvered")
            }
        }
    }
    
    func userDidTapDirections(for order: Delivery) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        guard let latitude = Double(order.latitude), let longitude = Double(order.longitude) else {
            self.navigationController.present(Utilities.showAlert("Incorrect latitude and longitude provided."), animated: true, completion: nil)
            return
        }
        let destinationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark.init(coordinate: destinationCoordinate)
        let mapItem = MKMapItem.init(placemark: placemark)
        mapItem.name = "Destination"
        mapItem.openInMaps(launchOptions: options)
    }
    
    func attachPhoto(_ detailsController: OrderDetailsViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = detailsController
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.navigationController.present(imagePicker, animated: true, completion: nil)
    }
}

