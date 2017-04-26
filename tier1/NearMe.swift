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

    
    var barViewControllers: [UIViewController]!
    var svc : eventTableView!
    
    let UR = CLLocationCoordinate2DMake(43.1284, -77.6289) //UR coordinates
    
    var model = Model()
    var ref: FIRDatabaseReference!
    var curEvent: event!
    
    var timer = Timer()
    
  /*  @IBAction func addCard(sender: AnyObject) {
        self.definesPresentationContext = true
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        // Cover Vertical is necessary for CurrentContext
        self.modalPresentationStyle = .currentContext
        // Display on top of    current UIView
        self.present(testVC(), animated: true, completion: nil)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()

        ref = FIRDatabase.database().reference()
        
        update()
        
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NearMe.onReturnUpdate), name:NSNotification.Name(rawValue: "unblurUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NearMe.onReturn), name:NSNotification.Name(rawValue: "unblur"), object: nil)
        
        barViewControllers = self.tabBarController?.viewControllers
        svc = (barViewControllers![1] as! UINavigationController).topViewController as! eventTableView!
        svc.model = self.model  //shared model

        
        mapView.showsUserLocation = true
        let region = MKCoordinateRegionMakeWithDistance(UR, 1700, 1700)
        mapView.setRegion(region, animated: true)

    }
    
    func onReturn() {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func onReturnUpdate() {
        update()
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func update()
    {
//        self.mapView.removeAnnotations(self.model.allEvents)
//        self.model.allEvents.removeAll()
        
        let earliest = String(NSDate().timeIntervalSince1970 - 14400)
        //get rid of events created more than 4 hours ago
        for e in 0..<self.model.allEvents.count {
            if (self.model.allEvents[e].eventTime.timeIntervalSince1970 < Double(earliest)! || self.model.allEvents[e].downVote >= 5) {
                self.mapView.removeAnnotation(self.model.allEvents[e])  //remove expired annotation from map
                self.model.allEvents.remove(at: e)  //remove expired event from internal model
            }
        }
        
        ref.child("events-v2").queryOrdered(byChild: "date").queryStarting(atValue: earliest).observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            for child in snap.children {
                var date = NSDate(), desc = String(), lat = Double(), long =  Double(), location = String(), submitted = NSDate(), type = Int(), up = Int(), down = Int()
                
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
                    
                    let newEvent = event(key, type, location, desc, date, submitted, CLLocationDegrees(lat), CLLocationDegrees(long), up, down)
                    
                    if(down < 5) {
                        self.model.allEvents.append(newEvent)
                        self.svc.model = self.model
                        self.mapView.addAnnotation(newEvent)
                    }
                    
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        update()
//        self.view.alpha = 1
        mapView.layoutSubviews()
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
        let _: MKAnnotationView
        if annotation is event {
                _ = color(annotation)
                if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//                view = annotationView as! MKAnnotationView
//                view.pinTintColor = pc
                annotationView.canShowCallout = true
                let e = annotation as! event
                if let img = e.getImg(false) {
                    annotationView.canShowCallout = true
                    annotationView.image = UIImage(named: img)

//                    annotationView.backgroundColor = UIColor.clear
           
                }
                return annotationView
            } else {
                let annotationView = MKAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
//                annotationView.pinTintColor = pc
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                let e = annotation as! event
                if let img = e.getImg(false) {
//                    print(img)
                    annotationView.canShowCallout = true
                    annotationView.image = UIImage(named: img)
//                    annotationView.backgroundColor = UIColor.clear
                }
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
        else if segue.identifier == "newEvent" {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            
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

