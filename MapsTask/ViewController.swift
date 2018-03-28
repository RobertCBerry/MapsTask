//
//  ViewController.swift
//  MapsTask
//
//  Created by Robert Berry on 3/27/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Sets the mapView's delegate as the view controller.
        
        mapView.delegate = self
        
        // The view controller class is set as the delegate for the location manager.
        
        locationManager.delegate = self
        
        // Set the location accuracy.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Specifies that the location data should only be read when the app is in the foreground.
        
        locationManager.requestWhenInUseAuthorization()
        
        // Method begins the generation of location updates.
        
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CLLocationManager Delegates
    
    // Method is called when when location updates are available.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Provides the most recent location as a CLLocationCoordinate2D object.
        
        let locationValue: CLLocationCoordinate2D = manager.location!.coordinate
        
        // Sets userLocation as the most recent location.
        
        userLocation = locationValue
        
        if userLocation != nil {
            
            // Stop updating the user's location.
            
            locationManager.stopUpdatingLocation()
            
            // Assigns latitude and longitude values to startLocation and endLocation constants.
            
            let startLocation = CLLocationCoordinate2D(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
            
            let endLocation = CLLocationCoordinate2D(latitude: 44.904019, longitude: -93.561654)
            
            // Provides a user friendly description of a location on a map.
            
            let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
            
            let endPlacemark = MKPlacemark(coordinate: endLocation, addressDictionary: nil)
            
            // Provides a point of interest on the map.
            
            let startMapItem = MKMapItem(placemark: startPlacemark)
            
            let endMapItem = MKMapItem(placemark: endPlacemark)
            
            // Creates MKPointAnnotation object.
            
            let startAnnotation = MKPointAnnotation()
            
            // Sets annotations title.
            
            startAnnotation.title = "Your current location."
            
            // Location coordinate that contains latitude and longitude information.
            
            if let location = startPlacemark.location {
                
                // Specifies the coordinate point of the annotation by latitude and longitude.
                
                startAnnotation.coordinate = location.coordinate
            }
            
            let endAnnotation = MKPointAnnotation()
            
            endAnnotation.title = "The developer's current location."
            
            if let location = endPlacemark.location {
                
                endAnnotation.coordinate = location.coordinate
            }
            
            // Sets the visible region of the map so that the annotations are displayed.
            
            mapView.showAnnotations([startAnnotation, endAnnotation], animated: true)
            
            // Creates an MKDirectionsRequest object, which sets the start and end points of a route, along with the mode of transportation between the two points.
            
            let directionRequest = MKDirectionsRequest()
            
            // The starting point for routing directions.
            
            directionRequest.source = startMapItem
            
            // The end point for routing directions.
            
            directionRequest.destination = endMapItem
            
            // The type of transportation which will be used on the route.
            
            directionRequest.transportType = .automobile
            
            // Creates MKDirections object that computes directions and travel time for the route you provide.
            
            let directions = MKDirections(request: directionRequest)
            
            // Calculates the requested route information.
            
            directions.calculate {
                
                (res,err) -> Void in
                
                // Confirms a MKDirections response is received.
                
                guard let res = res else {
                    
                    if let err = err {
                        
                        print("Error: \(err)")
                    }
                    
                    return
                }
                
                // Provides an array of route directions for the start and end points.
                
                let route = res.routes[0]
                
                // Adds an array of overlay objects at the specified level.
                
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                // Provides rectangle for the route.
                
                let rect = route.polyline.boundingMapRect
                
                // Changes the currently visible region.
                
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
            
        }
            
        else {
            
            // Creates UIAlertController
            
            let alertController = UIAlertController(title: "Error", message: "The app is not currently able to find your location.", preferredStyle: .alert)
            
            // UIAlertAction will allow the user to dismiss the alert. 
            
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            // Present alertController.
            
            present(alertController, animated: true)
        }
    }
    
    // Method called in case of an error receiving location updates.
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error: " + error.localizedDescription)
    }
    
    // MARK: Map View Delegate
    
    // Method returns an MKOverlayRenderer object that is used to draw a route on the map.
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let overlayRenderer = MKPolylineRenderer(overlay: overlay)
        
        overlayRenderer.strokeColor = .red
        
        overlayRenderer.lineWidth = 3.0
        
        return overlayRenderer
    }
} 



