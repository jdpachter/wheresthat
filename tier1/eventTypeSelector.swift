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
//    @IBOutlet weak var CampusImage: UIImageView!
    
    var ref: FIRDatabaseReference!
    var type: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = UIColor.clear
        //        view.isOpaque = false
        
        ref = FIRDatabase.database().reference()
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedType(tapGestureRecognizer:)))
//        CampusImage.addGestureRecognizer(tapGestureRecognizer)
        
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
    
//    func tappedType(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//        let selectedType = tapGestureRecognizer.view as! UIImageView
//        
//        if selectedType == CampusImage{
//            print("CAMPUS IMAGE!!!!!!!")
//            type = "Campus"
//        }
//    }
    
    @IBAction func selectedCampus(_ sender: Any) {
        type = "Campus"
    }
    
    
}
