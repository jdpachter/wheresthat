//
//  ViewController.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import MapKit

class NearMe: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let UR = CLLocationCoordinate2DMake(43.1284, -77.6289)// 0,0 Chicago street coordinates

    
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
//        mapView.showsUserLocation = true
        let region = MKCoordinateRegionMakeWithDistance(UR, 2500, 2500)
        mapView.setRegion(region, animated: true)
    
        model.genEvents()
        for i in model.allEvents {
            mapView.addAnnotation(i)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
//        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        mapView.removeAnnotation(newPin)
//        
//        let location = locations.last! as CLLocation
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        //set region on the map
//        map.setRegion(region, animated: true)
//        
//        newPin.coordinate = location.coordinate
//        map.addAnnotation(newPin)
//        
//    }


}

