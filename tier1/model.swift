//
//  model.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import Foundation
import MapKit

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
    
    var allEvents : [event] = []
    
    func genEvents() {
        for i in 0..<1 {
            let name = String(i)
            let location = String(i) + " Location"
//            let gps = CLLocationCoordinate2DMake(latitude: 43.1284, longitude: -77.6289) //rush rhees
            let details = "This is the description for event #" + String(i)
            let eventTime = NSDate(timeIntervalSinceNow: 10000)
            let submitTime = NSDate(timeIntervalSinceNow: 0)
            
            let newEvent = event(name, location, details, eventTime, submitTime, CLLocationDegrees(43.1284), CLLocationDegrees(-77.6289))
            allEvents.append(newEvent)
        }
    }
    
}
