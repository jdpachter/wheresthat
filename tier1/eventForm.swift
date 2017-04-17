//
//  eventForm.swift
//  tier1
//
//  Created by Joshua Pachter on 4/16/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Firebase
import FirebaseAuth

class eventForm: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var ref: FIRDatabaseReference!
    
    
    @IBOutlet var name: UITextField!
    @IBOutlet var location: UITextField!
    @IBOutlet var type: UIPickerView! = UIPickerView()
    @IBOutlet var typeText: UITextField!
    
    @IBAction func submit(sender: AnyObject) {
        
        if let desc = name.text, let loc = location.text, let eType = typeText.text {
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
        }
        
    }
    
    var typeOpts = ["Free Stuff", "Social Gathering", "Campus Event", "Study Group", "Public Safety"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()

        type.delegate = self
        type.dataSource = self
        typeText.inputView = type
        type.showsSelectionIndicator = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   }
    
    @IBAction func tappedOut(sender : AnyObject) {
        type.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOpts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOpts[row]
    }
    

    //delegate function for when a selection has been made
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeText.text = typeOpts[row]
    }
    
}
