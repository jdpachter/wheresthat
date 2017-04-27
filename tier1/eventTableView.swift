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
    @IBOutlet var add: UIBarButtonItem!
    
    var model: Model!
    
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    let UR = CLLocationCoordinate2DMake(43.1284, -77.6289) //UR coordinates
    var locEnabled = false

    
    var curEvent: event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locStatus()
        self.tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self

        
        self.model.sort()
        
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        if(locEnabled) {
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
            locValue = locationManager.location!.coordinate
        }
        else {
            add.isEnabled = false
        }
        
        
       
    }
    
    //http://stackoverflow.com/questions/34861941/check-if-location-services-are-enabled
    func locStatus() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                locEnabled = false
                locValue = UR
            case .authorizedAlways, .authorizedWhenInUse:
                locEnabled = true
            }
        } else {
            locEnabled = false
            locValue = UR
        }
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
        let eventName = event.title
        cell.eventTitle.text = eventName
        
        cell.eventTypeIcon.image = event.getImg()

        if(locEnabled) {
            cell.distance.text = String(describing: event.dist)
        } else {
            cell.distance.text = ""
            cell.miles.text = ""
        }
        return cell
    }
}
