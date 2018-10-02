//
//  MapViewController.swift
//  Hygiene App 2
//
//  Created by Tony Mcdonagh on 20/03/2018.
//  Copyright © 2018 Tony McDonagh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //Outlet for linking code to items on the app view
    @IBOutlet weak var myMapView: MKMapView!
    //Location manager for obtaining user location
    let locationManager = CLLocationManager()
    //Initialising variables
    var locations = [Place]()
    var oneLocation: Place?
    var current = false
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMapView.delegate = self
        
        //sets the locationMananger
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
        //sets map to standard view
        myMapView.mapType = .standard
        
        //calls function when the map loads
        userLocate()
        
        //if a list of businesses is passed, loop through adding pins for the locations
        if locations.count != 0 {
            for l in locations {
                let annotation = CustomPin()
                let lat = Double(l.Latitude!)
                let lon = Double(l.Longitude!)
                let sLat = Double(locations[0].Latitude!)
                let sLon = Double(locations[0].Longitude!)
                let ratingIm = String(l.RatingValue!)
                annotation.image = UIImage(named: ratingIm)
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                annotation.title = l.BusinessName
                var sub = ""
                //if the list is at the current location show business distance from user in Km
                if current == true {
                    let dKM = Double(l.DistanceKM!)
                    let displayKm = Double(round(1000*dKM!)/1000)
                    sub = "Distance from you \(displayKm) Km"}
                else {
                    sub = "\(l.AddressLine1!) \(l.AddressLine3!) \(l.PostCode!)"}
                annotation.subtitle = sub
                myMapView.addAnnotation(annotation)
                let searchView :CLLocationCoordinate2D = CLLocationCoordinate2DMake(sLat!, sLon!)
                let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                let searchRegion :MKCoordinateRegion = MKCoordinateRegionMake(searchView, span)
                myMapView.setRegion(searchRegion, animated: true)
            }
        }
            //if a single business is passed, display it and zoom in further
        else if oneLocation != nil {
            var l: Place
            l = oneLocation!
            let annotation = CustomPin()
            let lat = Double(l.Latitude!)
            let lon = Double(l.Longitude!)
            let ratingIm = String(l.RatingValue!)
            annotation.image = UIImage(named: ratingIm)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            annotation.title = l.BusinessName
            let sub = "\(l.AddressLine1!) \(l.AddressLine3!) \(l.PostCode!)"
            annotation.subtitle = sub
            myMapView.addAnnotation(annotation)
            let searchView :CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)
            let singleSpan :MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
            let searchRegion :MKCoordinateRegion = MKCoordinateRegionMake(searchView, singleSpan)
            myMapView.setRegion(searchRegion, animated: true)
            
        } else { // no data is passed the map will just display the user location
            }
        
    }
    
    //gets the users current location and adds pin
    func userLocate() {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMapView.setRegion(region, animated: true)
        let userLocation = CustomPin()
        userLocation.coordinate = location
        userLocation.title = "You are here!"
        userLocation.subtitle = "Why are you here??"
        userLocation.image = UIImage(named: "user")
        myMapView.addAnnotation(userLocation)
        
    }
    //handles the the locations and adds the pin to the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {return nil}
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPin
        annotationView!.image = customPointAnnotation.image
        return annotationView
    }
    
    //centres the map at the users location
    @IBAction func userLocationBtn(_ sender: Any) {
        userLocate()
    }
    

}
