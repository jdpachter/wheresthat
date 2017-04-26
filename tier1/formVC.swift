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

class formVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var ref: FIRDatabaseReference!
    
    var typeOpts = ["Free Stuff", "Social Gathering", "Campus Event", "Study Group", "Public Safety"]
    
    @IBOutlet var type: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var location: UITextField!
    @IBOutlet var typePicker: UIPickerView! = UIPickerView()
    
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unblur"), object: nil)
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.clear
//        view.isOpaque = false

        ref = FIRDatabase.database().reference()
        
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        typePicker.delegate = self
        typePicker.dataSource = self
        type.inputView = typePicker
        typePicker.showsSelectionIndicator = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        type.text = typeOpts[row]
    }
}
