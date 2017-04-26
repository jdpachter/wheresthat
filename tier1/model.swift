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
    
    var key: String //UID
    var type: Int
    var location: String        //user reported location
    var desc: String
    var eventTime: NSDate      //timestamp for when event to take place
    var submitTime: NSDate     //timestamp for when event reported
    var upVote: Int
    var downVote: Int
    var didVote: Int
    var dist: Double    //distance from current location
    var details: String
    
    init(_ key: String, _ type : Int, _ location : String, _ desc : String, _ eventTime : NSDate, _ submitTime : NSDate,
         _ lat:CLLocationDegrees, _ long:CLLocationDegrees, _ up: Int, _ down: Int, _ dist: Double, _ details: String) {
        self.type = type
        self.key = key
        self.title = desc
        self.location = location
        self.coordinate =  CLLocationCoordinate2DMake(lat, long)
        self.desc = desc
        self.eventTime = eventTime
        self.submitTime = submitTime
        self.upVote = up
        self.downVote = down
        self.didVote = 0    //-1 for downVote; 0 for no vote; 1 for upVote
        self.dist = dist
        self.details = details
    }
    
    func getImg() -> UIImage? {
        switch(type) {
        case 0:
            return #imageLiteral(resourceName: "Icon_FreeStuff")
        case 1:
            return #imageLiteral(resourceName: "Icon_SocialEvent")
        case 2:
            return #imageLiteral(resourceName: "Icon_CampusEvent")
        case 3:
            return #imageLiteral(resourceName: "Icon_StudyGroup")
        case 4:
            return #imageLiteral(resourceName: "Icon_PublicSafety")
        default:
            return nil
        }
    }
    
    func getPin() -> UIImage? {
        switch(type) {
        case 0:
            return #imageLiteral(resourceName: "Pin_FreeStuff_Small")
        case 1:
            return #imageLiteral(resourceName: "Pin_SocialEvent_Small")
        case 2:
            return #imageLiteral(resourceName: "Pin_CampusEvent_Small")
        case 3:
            return #imageLiteral(resourceName: "Pin_Studygroup_Small")
        case 4:
            return #imageLiteral(resourceName: "Pin_PublicSafety_Small")
        default:
            return nil
        }
    }
    
    func getType() -> String {
        switch(type) {
        case 0:
            return "Free Stuff"
        case 1:
            return "Social Gathering"
        case 2:
            return "Campus Event"
        case 3:
            return "Study Group"
        case 4:
            return "Public Safety"
        default:
            break
        }
        return ""
    }
    
}

//http://stackoverflow.com/questions/42351358/swift-custom-mkpointannotation-with-image
//class ImageAnnotationView: MKAnnotationView {
//    private var imageView: UIImageView!
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//
//        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        self.addSubview(self.imageView)
//
//        self.imageView.layer.cornerRadius = 5.0
//        self.imageView.layer.masksToBounds = true
//    }
//
//    override var image: UIImage? {
//        get {
//           return self.imageView.image
//        }
//
//        set {
//            self.imageView.image = newValue
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


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
    
    func lookupEvent(byCoordinate coordinate: CLLocationCoordinate2D) -> event? {
        for e in allEvents {
            if e.coordinate.latitude == coordinate.latitude && e.coordinate.longitude == coordinate.longitude {
                return e
            }
        }
        return nil
    }
    
    func sort() {
        allEvents = allEvents.sorted(by: { $0.dist < $1.dist })
    }
    
    func get(withKey key: String) -> event? {
        for e in allEvents {
            if e.key == key {
                return e
            }
        }
            return nil
    }
    
    func typeToString(_ type: Int) -> String {
        switch(type) {
        case 0:
            return "Free Stuff"
        case 1:
            return "Social Event"
        case 2:
            return "Campus Event"
        case 3:
            return "Study Group"
        case 4:
            return "Public Safety"
        default:
            break
        }
        return ""
    }
    
    func typeToColor(_ type: Int) -> UIColor {
        switch(type) {
        case 0:
            return UIColor.green
        case 1:
            return UIColor.blue
        case 2:
            return UIColor.yellow
        case 3:
            return UIColor.black
        case 4:
            return UIColor.red
        default:
            break
        }
        return UIColor.red
    }
  /*  func genEvents() {
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
