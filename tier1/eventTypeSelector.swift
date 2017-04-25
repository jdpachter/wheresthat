//
//  eventTypeSelector.swift
//  tier1
//
//  Created by Justin Maldonado on 4/24/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Firebase
import FirebaseAuth

class eventTypeSelector: UIViewController {
    @IBOutlet weak var CampusImage: UIImageView!
    @IBOutlet weak var FreeImage: UIImageView!
    @IBOutlet weak var PSImage: UIImageView!
    @IBOutlet weak var SocialImage: UIImageView!
    @IBOutlet weak var StudyImage: UIImageView!
    
    var ref: FIRDatabaseReference!
    var typeOpts = ["Free", "Social Event", "Campus", "Study Group", "Public Safety"]
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet var type: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var location: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        let tapCampus = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedCampus(_:)))
        tapCampus.numberOfTapsRequired = 1
        CampusImage.addGestureRecognizer(tapCampus)
        
        let tapFree = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedFree(_:)))
        tapCampus.numberOfTapsRequired = 1
        FreeImage.addGestureRecognizer(tapFree)
        
        let tapPS = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedPS(_:)))
        tapCampus.numberOfTapsRequired = 1
        PSImage.addGestureRecognizer(tapPS)
        
        let tapSocial = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedSocial(_:)))
        tapCampus.numberOfTapsRequired = 1
        SocialImage.addGestureRecognizer(tapSocial)
        
        let tapStudy = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedStudy(_:)))
        tapCampus.numberOfTapsRequired = 1
        StudyImage.addGestureRecognizer(tapStudy)
        
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    
    @IBAction func cancel(sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unblur"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendTypeToForm(){
        typeView.isHidden = true
        formView.isHidden = false
    }
    
    func selectedCampus(_ sender: Any) {
        type.text = "Campus"
        sendTypeToForm()
        print("CLICKED CAMPUS")
    }
    func selectedFree(_ sender: Any) {
        type.text = "Free"
        sendTypeToForm()
        print("CLICKED FREE")
    }
    func selectedPS(_ sender: Any) {
        type.text = "Public Safety"
        sendTypeToForm()
        print("CLICKED PS")
    }
    func selectedSocial(_ sender: Any) {
        type.text = "Social Event"
        sendTypeToForm()
        print("CLICKED SOCIAL")
    }
    func selectedStudy(_ sender: Any) {
        type.text = "Study Group"
        sendTypeToForm()
        print("CLICKED STUDY")
    }
    
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
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unblurUpdate"), object: nil)
                self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func tappedOut(sender : AnyObject) {
        //        type.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
}
