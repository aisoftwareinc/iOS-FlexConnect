//
//  MapController.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class MapController: UIViewController {
    
    let directions: DirectionDetails
    let origin: CLLocation
    let destination: CLLocation
    private var route: MKRoute!
    var mapView: MKMapView!
    
    init(_ directions: DirectionDetails, _ origin: CLLocation, _ destination: CLLocation) {
        self.directions = directions
        self.origin = origin
        self.destination = destination
        super.init(nibName: nil, bundle: nil)
        self.fetchDirections()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView = MKMapView.init(frame: self.view.frame)
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        // Do any additional setup after loading the view.
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchDirections() {
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.transportType = .automobile
        directionsRequest.source = MKMapItem.init(placemark: MKPlacemark.init(coordinate: self.origin.coordinate))
        directionsRequest.destination = MKMapItem.init(placemark: MKPlacemark.init(coordinate: self.destination.coordinate))
        
        let drivingDirections = MKDirections.init(request: directionsRequest)
        drivingDirections.calculate { (directionsResponse, error) in
            self.route = directionsResponse!.routes.first!
            self.displayDirections()
        }
    }

    func displayDirections() {
        self.mapView.add(self.route.polyline, level: .aboveRoads)
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer.init(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
}
