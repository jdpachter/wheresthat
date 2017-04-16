//
//  ViewController.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth
import GoogleSignIn


class NearMe: UIViewController, MKMapViewDelegate, GIDSignInUIDelegate  {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    let UR = CLLocationCoordinate2DMake(43.1284, -77.6289)// 0,0 Chicago street coordinates
    

//    var handle: FIRAuthStateDidChangeListenerHandle?
    var model = Model()
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()

        ref = FIRDatabase.database().reference()
//        let testQ = (ref?.child("events"))!

        ref.child("events").queryOrdered(byChild: "date").observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            for child in snap.children{
                print(child)
                if let date = (child as AnyObject).childSnapshot(forPath: "date").value {
                    let uStamp = (Double(String(describing: date))!)
                    print(NSDate(timeIntervalSince1970: uStamp))
                }
            }
        }
        
//        mapView.showsUserLocation = true
        let region = MKCoordinateRegionMakeWithDistance(UR, 1700, 1700)
        mapView.setRegion(region, animated: true)
//        model.genEvents()
        for i in model.allEvents {
            mapView.addAnnotation(i)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        handle = FIRAuth.auth()?.addStateDidChangeListener() {}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
//        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "eventPin"
        
        if annotation is event {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView.annotation = annotation
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                return annotationView
            }
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
         performSegue(withIdentifier: "toEventPage", sender: view)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       
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

