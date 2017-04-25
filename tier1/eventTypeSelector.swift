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
    var type: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        let tapCampus = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedCampus(_:)))
        tapCampus.numberOfTapsRequired = 1
        CampusImage.addGestureRecognizer(tapCampus)
        
        let tapFree = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedFree(_:)))
        tapCampus.numberOfTapsRequired = 1
        CampusImage.addGestureRecognizer(tapFree)
        
        let tapPS = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedPS(_:)))
        tapCampus.numberOfTapsRequired = 1
        CampusImage.addGestureRecognizer(tapPS)
        
        let tapSocial = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedSocial(_:)))
        tapCampus.numberOfTapsRequired = 1
        CampusImage.addGestureRecognizer(tapSocial)
        
        let tapStudy = UITapGestureRecognizer(target: self, action: #selector(eventTypeSelector.selectedStudy(_:)))
        tapCampus.numberOfTapsRequired = 1
        CampusImage.addGestureRecognizer(tapStudy)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            if let eventForm = segue.destination as? formVC {
                eventForm.type.text = type
            }
        }
    }
    
    func selectedCampus(_ sender: Any) {
        type = "Campus"
    }
    func selectedFree(_ sender: Any) {
        type = "Free"
    }
    func selectedPS(_ sender: Any) {
        type = "Public Safety"
    }
    func selectedSocial(_ sender: Any) {
        type = "Social"
    }
    func selectedStudy(_ sender: Any) {
        type = "Study Group"
    }
    
    
}
