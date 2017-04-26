//
//  eventPage.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import Firebase

class eventPage: UIViewController {
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet var eventName : UILabel!
    @IBOutlet var location : UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var type: UILabel!
    
    @IBOutlet var thumbsUp: UIButton!
    @IBOutlet var thumbsDown: UIButton!
    
    @IBAction func upVote(sender: AnyObject) {
        if(event.didVote == 0) {
            let uid = event.key
            let newUp = event.upVote + 1
            ref.child("events-v2/"+uid+"/up").setValue(newUp)
            event.didVote = 1
            event.upVote = newUp
            updateThumbs()
        }
    }
    
    @IBAction func downVote(sender: AnyObject) {
        if(event.didVote == 0) {
            let uid = event.key
            let newDown = event.downVote + 1
            ref.child("events-v2/"+uid+"/down").setValue(newDown)
            event.didVote = -1
            event.upVote = newDown
            updateThumbs()
            
        }
    }
    
    var event: event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        eventName.text = event.desc
        location.text = event.location
        type.text = event.getType()
        if let typeImage = event.getImg(true) {
            img.image = UIImage(named: typeImage)
            img.sizeToFit()

        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        let strDateM = dateFormatter.string(from: event.eventTime as Date)
        dateFormatter.dateFormat = "h:mm a"
        let strDateTime = dateFormatter.string(from: event.eventTime as Date)
        time.text = strDateM + " at " + strDateTime
        
        updateThumbs()
        
    }
    
    func updateThumbs() {
        switch(event.didVote) {
        case -1:
            let img = UIImage(named: "thumbs-down-red")
            thumbsDown.setBackgroundImage(img, for: .normal)
            thumbsUp.isEnabled = false
            thumbsDown.isEnabled = false
        case 1:
            let img = UIImage(named: "thumbs-up-green")
            thumbsUp.setBackgroundImage(img, for: .normal)
            thumbsUp.isEnabled = false
            thumbsDown.isEnabled = false
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

