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
    var typeIcon: UIImage!
    
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
        
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        navigationController?.navigationBar.layer.shadowOpacity = 0
        
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        titleLabel.text = "Add Event"
//        titleLabel.textColor = DARK_BLUE
//        titleLabel.font = UIFont(name: "Roboto-Bold", size: 25)
//        navigationItem.titleView = titleLabel
    }
    
    @IBAction func cancel(sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFormVC"{
            if let formVC = segue.destination as? formVC{
                formVC.presetType = type
                formVC.presetIcon = typeIcon
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
    
    func sendTypeToForm(){
        performSegue(withIdentifier: "toFormVC", sender: self)
    }
    
    func selectedCampus(_ sender: Any) {
        type = "Campus Event"
        typeIcon = #imageLiteral(resourceName: "Icon_CampusEvent")
        sendTypeToForm()
        print("CLICKED CAMPUS")
    }
    func selectedFree(_ sender: Any) {
        type = "Free Stuff"
        typeIcon = #imageLiteral(resourceName: "Icon_FreeStuff")
        sendTypeToForm()
        print("CLICKED FREE")
    }
    func selectedPS(_ sender: Any) {
        type = "Public Safety"
        typeIcon = #imageLiteral(resourceName: "Icon_PublicSafety")
        sendTypeToForm()
        print("CLICKED PS")
    }
    func selectedSocial(_ sender: Any) {
        type = "Social Event"
        typeIcon = #imageLiteral(resourceName: "Icon_SocialEvent")
        sendTypeToForm()
        print("CLICKED SOCIAL")
    }
    func selectedStudy(_ sender: Any) {
        type = "Study Group"
        typeIcon = #imageLiteral(resourceName: "Icon_StudyGroup")
        sendTypeToForm()
        print("CLICKED STUDY")
    }
    
    
}
