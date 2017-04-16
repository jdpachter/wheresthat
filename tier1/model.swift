//
//  model.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import Foundation
import MapKit
import Firebase
import FirebaseAuth

class event : NSObject, MKAnnotation {
    var identifier = "eventPin"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    var name : String
    var location: String        //user reported location
    var details: String
    var eventTime : NSDate      //timestamp for when event to take place
    var submitTime : NSDate     //timestamp for when event reported
    
    init(_ name : String, _ location : String, _ details : String, _ eventTime : NSDate, _ submitTime : NSDate,
         _ lat:CLLocationDegrees, _ long:CLLocationDegrees) {
        self.name = name
        self.title = name
        self.location = location
        self.coordinate =  CLLocationCoordinate2DMake(lat, long)
        self.details = details
        self.eventTime = eventTime
        self.submitTime = submitTime
    }
    
}


class Model {
    
    var allEvents = [event]()
//    
//    var ref: FIRDatabaseReference!
//
//    init() {
//        ref = FIRDatabase.database().reference()
//        let testQ = (ref?.child("events"))!
//        print(testQ)
//    }
    
    func getEvents() {
        
//        FIRAuth.auth()?.signInAnonymously() { (user, error) in
//            let isAnonymous = user!.isAnonymous //true
//            let uid = user!.uid
//        }
        
//        let usersRef = self.myRootRef.childByAppendingPath("events")
        
    }
   /* func genEvents() {
        var name = "Puppies"
        var location = "Rush Rhees"
        //            let gps = CLLocationCoordinate2DMake(latitude: 43.1284, longitude: -77.6289) //rush rhees
        var details = "Pet puppies in Rush Rhees!"
        var eventTime = NSDate(timeIntervalSinceNow: 10000)
        var submitTime = NSDate(timeIntervalSinceNow: 0)
        
        var newEvent = event(name, location, details, eventTime, submitTime, CLLocationDegrees(43.1284), CLLocationDegrees(-77.6289))
        allEvents.append(newEvent)
        
        name = "Free Shirts"
        location = "Hirst Lounge"
        //            let gps = CLLocationCoordinate2DMake(latitude: 43.1284, longitude: -77.6289) //rush rhees
        details = "Free shirts in hirst!"
        eventTime = NSDate(timeIntervalSinceNow: 15000)
        submitTime = NSDate(timeIntervalSinceNow: 0)
        
        var newEvent2 = event(name, location, details, eventTime, submitTime, CLLocationDegrees(43.1286), CLLocationDegrees(-77.6296))

        allEvents.append(newEvent2)
    }*/
    
}
