//
//  formVC.swift
//  tier1
//
//  Created by Joshua Pachter on 4/22/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Firebase
import FirebaseAuth

class formVC: UIViewController {
    
    var ref: FIRDatabaseReference!
    
    var presetType: String!
    var presetIcon: UIImage!
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet var name: UITextField!
    @IBOutlet var location: UITextField!
    @IBOutlet var details: UITextField!
    //    @IBOutlet var typePicker: UIPickerView! = UIPickerView()
    
    @IBAction func submit(sender: AnyObject) {
        
        if let desc = name.text, let loc = location.text, let eType = type.text, let deets = details.text {
            if desc != "" && loc != "" && eType != "" {
                let locManager = CLLocationManager()
                let lat = locManager.location?.coordinate.latitude
                let long = locManager.location?.coordinate.longitude
                let now = NSDate().timeIntervalSince1970
                
                let coor = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                if(!NearMe.fence.contains(coor)) {
                    self.alert("Out of Bounds","Please enter an event happening on or near campus.", true)
                }
                else {
                    let post:[String: String] = [
                        "date":String(now),
                        "desc":desc,
                        "location":loc,
                        "type":String(describing: typeOpts.index(of: eType)!),
                        "lat":String(describing: lat!),
                        "long":String(describing: long!),
                        "submitted":String(now),
                        "up":"0",
                        "down":"0",
                        "details": deets]
                    
                    ref.child("events-v3").childByAutoId().setValue(post)
                    
                    let viewControllers: [UIViewController] = (navigationController?.viewControllers)!
                    navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
            }
            else {
                self.alert("Missing Information", "Please fill in all fields.", false)
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let viewControllers: [UIViewController] = (navigationController?.viewControllers)!
        navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type.text = presetType
        typeIcon.image = presetIcon
        
        ref = FIRDatabase.database().reference()
        
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        navigationController?.navigationBar.layer.shadowOpacity = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedOut(sender : AnyObject) {
        
        self.view.endEditing(true)
    }

    func alert(_ title: String, _ msg: String, _ ret: Bool) {
        let saveMyAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        saveMyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:
            UIAlertAction!) in
        }))
        if(ret) {
            present(saveMyAlert, animated: true) {
                self.cancel(sender: self)
            }
        }
        else {
           present(saveMyAlert, animated: true, completion: nil)
        }
     
        
    }
}
