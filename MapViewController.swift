//
//  ViewController.swift
//  GCA
//
//  Created by Nick Hunziker on 1/22/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 43.061827, longitude: -73.744951, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        // sets the map type to satellite. ranges 1-5 for different types
        mapView.mapType = GMSMapViewType(rawValue: 4)!
        self.view.addSubview(mapView)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 43.061827, longitude: -73.744951)
        marker.title = "Saratoga National"
        marker.snippet = "New York"
        marker.map = mapView

        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        // An array to hold the list of likely places.
        var likelyPlaces: [GMSPlace] = []
        // The currently selected place.
        var selectedPlace: GMSPlace?
        
    }
    


}
