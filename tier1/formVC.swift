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

class formVC: UIViewController{
    
    var ref: FIRDatabaseReference!
    
    var typeOpts = ["Free", "Social Event", "Campus", "Study Group", "Public Safety"]
    var presetType: String!
    
    @IBOutlet var type: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var location: UITextField!
//    @IBOutlet var typePicker: UIPickerView! = UIPickerView()
    
    @IBAction func submit(sender: AnyObject) {
        
        if let desc = name.text, let loc = location.text, let eType = type.text {
            if desc != "" && loc != "" && eType != "" {
                let locManager = CLLocationManager()
                let lat = locManager.location?.coordinate.latitude
                let long = locManager.location?.coordinate.longitude
                let now = NSDate().timeIntervalSince1970
                
                let post:[String: String] = [
                    "date":String(now),
                    "desc":desc,
                    "location":loc,
                    "type":String(describing: typeOpts.index(of: eType)!),
                    "lat":String(describing: lat!),
                    "long":String(describing: long!),
                    "submitted":String(now)]
                
                ref.child("events").childByAutoId().setValue(post)
                
                let saveMyAlert = UIAlertController(title: "Event Submitted!", message: "Go see it on the map!", preferredStyle: UIAlertControllerStyle.alert)
                saveMyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:
                    UIAlertAction!) in
                }))
                present(saveMyAlert, animated: true, completion: nil)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unblurUpdate"), object: nil)
                dismiss(animated: true, completion: nil)
                
            }
            else {
                let saveMyAlert = UIAlertController(title: "Missing Information", message: "Please fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
                saveMyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:
                    UIAlertAction!) in
                }))
                present(saveMyAlert, animated: true, completion: nil)
            }
        }
    }

    
    @IBAction func cancel(sender: AnyObject) {
        let tabController = storyboard?.instantiateViewController(withIdentifier: "tabController")
        present(tabController!, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        type.text = presetType

        ref = FIRDatabase.database().reference()
        
        self.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.formSheet
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedOut(sender : AnyObject) {
        self.view.endEditing(true)
    }
    
}
