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

class eventTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model: Model!
    
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    
    var curEvent: event!
    
    override func viewDidLoad() {
        self.tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.model.sort()
        
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        locValue = locationManager.location!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.allEvents.count
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventPageT" {
            if let eventPage = segue.destination as? eventPage {
                eventPage.event = curEvent
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let e = self.model.lookupEvent(byCoordinate: (model.allEvents[indexPath.row].coordinate)) {
            curEvent = e
        }
        performSegue(withIdentifier: "toEventPageT", sender: self.view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! eventCell
        let event = model.allEvents[indexPath.row]
        let eventName = event.desc
        let eventType = model.typeToString(event.type)
        cell.eventTitle.text = eventName
        cell.eventType.text = eventType
        
        let typeNum = event.type
        var typeImage = #imageLiteral(resourceName: "WheresThat_LogoIcon")
        
        switch(typeNum){
        case 0: typeImage = #imageLiteral(resourceName: "freeStuffBig")
        case 1: typeImage = #imageLiteral(resourceName: "socialGatheringBig")
        case 2: typeImage = #imageLiteral(resourceName: "campusGatheringBig")
        case 3: typeImage = #imageLiteral(resourceName: "studyGroupBig")
        case 4: typeImage = #imageLiteral(resourceName: "publicSafetyBig")
        default:
            print("Event Icon Grab Error!")
        }
        cell.eventTypeIcon.image = typeImage

        cell.distance.text = String(describing: event.dist)
        return cell
    }
}
