//
//  eventTableView.swift
//  tier1
//
//  Created by Joshua Pachter on 4/17/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class eventTableView: UITableViewController, CLLocationManagerDelegate {
    
    var model: Model!
    
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D!
    
    var curEvent: event!
    
    override func viewDidLoad() {
        self.tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(eventTableView.unblur), name:NSNotification.Name(rawValue: "unblur"), object: nil)
        
        locValue = CLLocationCoordinate2D()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
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
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.getCount(section)
    }
    
    func unblur() {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventPageT" {
            if let eventPage = segue.destination as? eventPage {
                eventPage.event = curEvent
            }
        }
        else if segue.identifier == "newFromTV" {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            
        }
        
    }
    
    /*func getTableCell(_ path: IndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: path) as! customCell
        
        cell.updateLabels()

        let current = model.allEvents[path.row]
        cell.desc?.text = current.desc
        cell.type?.text = model.typeToString(current.type)
        if let im = current.getImg(false) {
            cell.img?.image = UIImage(named: im)
        }
        return cell
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let e = self.model.lookupEvent(byCoordinate: (model.allEvents[indexPath.row].coordinate)) {
            curEvent = e
        }
        performSegue(withIdentifier: "toEventPageT", sender: self.view)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        print(String(describing: indexPath.row) + "\n")
      
        

            
        switch(indexPath.section) {
        case 0:
            let event = model.getEvents(ofType: 0)[indexPath.row]
            let eventName = event.desc
            //need to get current location and location by section.
            //go through getEvents and calculate location for each event. Similar method to getEvents.
            //var distance = myLocation.distanceFromLocation(eventPinLoc) / 1000 this converstion is from meters--> miles.
           // let eventType = 0
            
            let myLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            let otherLoc = CLLocation(latitude: event.coordinate.latitude, longitude: event.coordinate.longitude)
            let distance = myLoc.distance(from: otherLoc)
            
            cell.textLabel?.text = eventName
            cell.detailTextLabel?.text = String(describing: distance)
            
        
        case 1:
            
            let event = model.getEvents(ofType: 1)[indexPath.row]
            let eventName = event.desc 
            
            
           // let eventType = 1
            
            
            let myLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            let otherLoc = CLLocation(latitude: event.coordinate.latitude, longitude: event.coordinate.longitude)
            let distance = myLoc.distance(from: otherLoc)
        
            
            cell.textLabel?.text = eventName
            cell.detailTextLabel?.text = String(describing: distance)
        case 2:
            
            let event = model.getEvents(ofType: 2)[indexPath.row]
            let eventName = event.desc
            
            
            // let eventType = 1
            
            
            let myLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            let otherLoc = CLLocation(latitude: event.coordinate.latitude, longitude: event.coordinate.longitude)
            let distance = myLoc.distance(from: otherLoc)
            
            
            cell.textLabel?.text = eventName
            cell.detailTextLabel?.text = String(describing: distance)

        case 3:
            
            let event = model.getEvents(ofType: 3)[indexPath.row]
            let eventName = event.desc
            
            
            // let eventType = 1
            
            
            let myLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            let otherLoc = CLLocation(latitude: event.coordinate.latitude, longitude: event.coordinate.longitude)
            let distance = myLoc.distance(from: otherLoc)
            
            
            cell.textLabel?.text = eventName
            cell.detailTextLabel?.text = String(describing: distance)

        case 4:
            
            let event = model.getEvents(ofType: 4)[indexPath.row]
            let eventName = event.desc
            
            
            // let eventType = 1
            
            
            let myLoc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            let otherLoc = CLLocation(latitude: event.coordinate.latitude, longitude: event.coordinate.longitude)
            let distance = myLoc.distance(from: otherLoc)
            
            
            cell.textLabel?.text = eventName
            cell.detailTextLabel?.text = String(describing: distance)

        default:
            break
        }
       
        
//        cell.textLabel?.textColor = model.typeToColor(model.allEvents[indexPath.row].type)
        return cell
    }
}
