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
    
    var tapped = false
    
    
    @IBAction func buttonTapped(sender : UILongPressGestureRecognizer ) {
        if tapped == false {
            if let current = sender.view {
                current.alpha = 0.5
                switch(current.tag) {
                case 0:
                    type = "Campus Event"
                    typeIcon = #imageLiteral(resourceName: "Icon_CampusEvent")
                    sendTypeToForm()
                    print("CLICKED CAMPUS")
                case 1:
                    type = "Free Stuff"
                    typeIcon = #imageLiteral(resourceName: "Icon_FreeStuff")
                    sendTypeToForm()
                    print("CLICKED FREE")
                case 2:
                    type = "Public Safety"
                    typeIcon = #imageLiteral(resourceName: "Icon_PublicSafety")
                    sendTypeToForm()
                    print("CLICKED PS")
                case 3:
                    type = "Social Event"
                    typeIcon = #imageLiteral(resourceName: "Icon_SocialEvent")
                    sendTypeToForm()
                    print("CLICKED SOCIAL")
                case 4:
                    type = "Study Group"
                    typeIcon = #imageLiteral(resourceName: "Icon_StudyGroup")
                    sendTypeToForm()
                    print("CLICKED STUDY")
                default:
                    break
                }
                tapped = true
            }
        }
    }
    
    var ref: FIRDatabaseReference!
    var type: String!
    var typeIcon: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        navigationController?.navigationBar.layer.shadowOpacity = 0
        
        //        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        //        titleLabel.text = "Add Event"
        //        titleLabel.textColor = DARK_BLUE
        //        titleLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        //        navigationItem.titleView = titleLabel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tapped = false
        
        CampusImage.alpha = 1
        FreeImage.alpha = 1
        PSImage.alpha = 1
        SocialImage.alpha = 1
        StudyImage.alpha = 1
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
    
}
