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
    
    let UR = CLLocationCoordinate2DMake(43.1284, -77.6289) //UR coordinates
    

//    var handle: FIRAuthStateDidChangeListenerHandle?
    var model = Model()
    var ref: FIRDatabaseReference!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()

        ref = FIRDatabase.database().reference()
        
        update()
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = (barViewControllers![1] as! UINavigationController).topViewController as! eventTableView
        svc.model = self.model  //shared model
        
//        mapView.showsUserLocation = true
        let region = MKCoordinateRegionMakeWithDistance(UR, 1700, 1700)
        mapView.setRegion(region, animated: true)
//        model.genEvents()
        /*for i in model.allEvents {
            mapView.addAnnotation(i)
        }*/
    }
    
    
    
    func update()
    {
        self.mapView.removeAnnotations(self.model.allEvents)
        self.model.allEvents.removeAll()
        let earliest = String(NSDate().timeIntervalSince1970 - 14400)
        ref.child("events").queryOrdered(byChild: "date").queryStarting(atValue: earliest).observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            for child in snap.children {
                var date = NSDate(), desc = String(), lat = Double(), long =  Double(), location = String(), submitted = NSDate(), type = Int()
                //get date
                if let data = (child as AnyObject).childSnapshot(forPath: "date").value {
                    let uStamp = (Double(String(describing: data))!)    //convert to unix timestamp
                    date = NSDate(timeIntervalSince1970: uStamp)
                }
                
                //get desc
                if let data = (child as AnyObject).childSnapshot(forPath: "desc").value {
                    desc = (String(describing: data))
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
                
                let newEvent = event(type, location, desc, date, submitted, CLLocationDegrees(lat), CLLocationDegrees(long))
                self.model.allEvents.append(newEvent)
                self.mapView.addAnnotation(newEvent)
            }
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
        let view: MKPinAnnotationView
        if annotation is event {
                let pc = color(annotation)
                if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                view = annotationView as! MKPinAnnotationView
                view.pinTintColor = pc
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                annotationView.pinTintColor = pc
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
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

