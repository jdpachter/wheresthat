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
import CoreLocation
import CoreData
import FBSDKLoginKit
import FBSDKCoreKit


class NearMe: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet var mapView: MKMapView!
//    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet var add: UIBarButtonItem!
    @IBOutlet var goToLoc: UIButton!
    
    var barViewControllers: [UIViewController]!
    var svc : eventTableView!
    var locEnabled = false
    
    let UR = CLLocationCoordinate2DMake(43.1284, -77.6289) //UR coordinates
    
    let locManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D!

    static var fence: CLCircularRegion!
    
    var model = Model()
    var ref: FIRDatabaseReference!
    var curEvent: event!
    
    var timer = Timer()
    
    @IBAction func goToCurrentLoc(sender: AnyObject) {
        mapView.showsUserLocation = true
        let region = MKCoordinateRegionMakeWithDistance(locValue, 950, 950)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func logout(sender: AnyObject){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            OperationQueue.main.addOperation {
                [weak self] in
                self?.performSegue(withIdentifier: "logOut", sender: self)
            }
            print("logout")
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    func locStatus() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                locEnabled = false
                locValue = UR
                self.add.isEnabled = false
                self.goToLoc.isHidden = true
            case .authorizedAlways, .authorizedWhenInUse:
                locEnabled = true
                self.add.isEnabled = true
                self.goToLoc.isHidden = false
            }
        } else {
            locEnabled = false
            locValue = UR
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locStatus()

        makeFence()
        
        barViewControllers = self.tabBarController?.viewControllers
        svc = (barViewControllers![1] as! UINavigationController).topViewController as! eventTableView!
        svc.model = self.model  //shared model
        locManager.delegate = self
        if(locEnabled) {
            locValue = CLLocationCoordinate2D()
            self.locManager.requestWhenInUseAuthorization()
        
            if CLLocationManager.locationServicesEnabled() {
                locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locManager.startUpdatingLocation()
            }
            mapView.showsUserLocation = true
            locationManager(locManager, didUpdateLocations: [])
        }
        else {
            add.isEnabled = false
            goToLoc.isHidden = true
        }

        let region = MKCoordinateRegionMakeWithDistance(locValue, 950, 950)
        mapView.setRegion(region, animated: true)
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2
        
        DataService.ds.REF_EVENTS.observe(.value, with: { (snapshot) in
            print(snapshot.value)
            for child in snapshot.children {
                var date = NSDate(), title = String(), lat = Double(), long =  Double(), location = String(), submitted = NSDate(), type = Int(), up = Int(), down = Int(), dist = Double(), details = String()
                
                let key = (child as! FIRDataSnapshot).key
                
                if let data =  (child as AnyObject).childSnapshot(forPath: "up").value {
                    up = (Int(String(describing: data))!)
                }
                
                if let data =  (child as AnyObject).childSnapshot(forPath: "down").value {
                    down = (Int(String(describing: data))!)
                }
                
                if let hasKey = self.model.get(withKey: key) {
                    hasKey.upVote = up
                    hasKey.downVote = down
                }
                else {
                    //get date
                    if let data = (child as AnyObject).childSnapshot(forPath: "date").value {
                        let uStamp = (Double(String(describing: data))!)    //convert to unix timestamp
                        date = NSDate(timeIntervalSince1970: uStamp)
                    }
                    
                    //get desc
                    if let data = (child as AnyObject).childSnapshot(forPath: "title").value {
                        title = (String(describing: data))
                    }
                    
                    //get type
                    if let data = (child as AnyObject).childSnapshot(forPath: "type").value {
                        type = (Int(String(describing: data))!)
                    }
                    
                    //get location
                    if let data = (child as AnyObject).childSnapshot(forPath: "location").value {
                        location = (String(describing: data))
                    }
                    
                    //get long
                    if let data = (child as AnyObject).childSnapshot(forPath: "long").value {
                        long = (Double(String(describing: data))!)
                    }
                    
                    //get lat
                    if let data = (child as AnyObject).childSnapshot(forPath: "lat").value {
                        lat = (Double(String(describing: data))!)
                    }
                    
                    //get submitted
                    if let data = (child as AnyObject).childSnapshot(forPath: "submitted").value {
                        let uStamp = (Double(String(describing: data))!)    //convert to unix timestamp
                        submitted = NSDate(timeIntervalSince1970: uStamp)
                    }
                    
                    //get details
                    if let data = (child as AnyObject).childSnapshot(forPath: "details").value {
                        details = String(describing: data)
                    }
                    
                    //get distance
                    let myLoc = CLLocation(latitude: self.locValue.latitude, longitude: self.locValue.longitude)
                    let otherLoc = CLLocation(latitude: lat, longitude: long)
                    dist = myLoc.distance(from: otherLoc)
                    
                    dist /= 1609.344
                    dist = Double(round(dist*100)/100)
                    
                    let newEvent = event(key, type, location, title, date, submitted, CLLocationDegrees(lat), CLLocationDegrees(long), up, down, dist, details)
                    
                    if(down < 5) {
                        self.model.allEvents.append(newEvent)
                        self.model.sort()
                        self.svc.model = self.model
                        self.mapView.addAnnotation(newEvent)
                    }
                }
            }
        })
    }
    
    
    func makeFence() {
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(43.1284, -77.6289)
        let radius:CLLocationDistance = CLLocationDistance(1200)
        NearMe.fence =  CLCircularRegion(center: center, radius: radius, identifier: "UR")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let val = manager.location {
            locValue = val.coordinate
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.layoutSubviews()
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
//        let region = MKCoordinateRegionMakeWithDistance(locValue, 950, 950)
//        mapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


//    func mapView(_ mapView: MKMapView, didUpdate
//        userLocation: MKUserLocation) {
////        mapView.centerCoordinate = userLocation.location!.coordinate
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "eventPin"
        let _: MKAnnotationView
        if annotation is event {
                _ = color(annotation)
                if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView.canShowCallout = true
                let e = annotation as! event
                if let img = e.getPin() {
                    annotationView.canShowCallout = true
                    annotationView.image = img
                    
                }
                    annotationView.layer.cornerRadius = 0.0
                    annotationView.layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
                    annotationView.layer.shadowOpacity = 0.85
                    annotationView.layer.shadowRadius = 5.0
                    annotationView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                    annotationView.centerOffset = CGPoint(x: 0, y: -annotationView.frame.size.height/2)
                    
                return annotationView
            } else {
                let annotationView = MKAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                let e = annotation as! event

                if let img = e.getPin() {
                    annotationView.canShowCallout = true
                    annotationView.image = img
                }
                    annotationView.layer.cornerRadius = 0.0
                    annotationView.layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
                    annotationView.layer.shadowOpacity = 0.85
                    annotationView.layer.shadowRadius = 5.0
                    annotationView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                    annotationView.centerOffset = CGPoint(x: 0, y: -annotationView.frame.size.height/2)
                return annotationView
            }
        }
        
        return nil
    }
    
    func color(_ annotation: MKAnnotation) -> UIColor {
        let myAnnotation = annotation as! event
        let type = myAnnotation.type
        let pinColor: UIColor
        
        switch (type){
            case 0: pinColor = .green
            case 1: pinColor = .blue
            case 2: pinColor = .yellow
            case 3: pinColor = .black
            default: pinColor = .red
        }
        return pinColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventPage" {
            if let eventPage = segue.destination as? eventPage {
                eventPage.event = curEvent
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let e = self.model.lookupEvent(byCoordinate: (view.annotation?.coordinate)!) {
            curEvent = e
        }
        performSegue(withIdentifier: "toEventPage", sender: view)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       
    }
    
}

