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
                    "submitted":String(now),
                    "up":"0",
                    "down":"0"]
                
                ref.child("events-v2").childByAutoId().setValue(post)
                
                let viewControllers: [UIViewController] = (navigationController?.viewControllers)!
                navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
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
    
}
