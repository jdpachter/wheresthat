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
    @IBOutlet var name: UILabel!
    @IBOutlet weak var details: UILabel!
    
    @IBOutlet var thumbsUp: UIButton!
    @IBOutlet var thumbsDown: UIButton!
    @IBOutlet var votes: UILabel!
    
    @IBAction func upVote(sender: AnyObject) {
        if(event.didVote == 0) {
            let uid = event.key
            let newUp = event.upVote + 1
            ref.child("events-v3/"+uid+"/up").setValue(newUp)
            event.didVote = 1
            event.upVote = newUp
            updateThumbs()
        }
    }
    
    @IBAction func downVote(sender: AnyObject) {
        if(event.didVote == 0) {
            let uid = event.key
            let newDown = event.downVote + 1
            ref.child("events-v3/"+uid+"/down").setValue(newDown)
            event.didVote = -1
            event.downVote = newDown
            updateThumbs()
            
        }
    }
    
    var event: event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        eventName.text = event.title
        location.text = event.location
        name.text = event.title
        details.text = event.details
        votes.text = String(describing: event.upVote - event.downVote)
        if let typeImage = event.getImg() {
            img.image = typeImage
            img.sizeToFit()

        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "EEEE, MMMM dd"
//        let strDateM = dateFormatter.string(from: event.eventTime as Date)
        dateFormatter.dateFormat = "h:mm a"
        let strDateTime = dateFormatter.string(from: event.eventTime as Date)
        time.text = strDateTime//strDateM + " at " + strDateTime
        navigationController?.navigationBar.layer.shadowOpacity = 0
        
        updateThumbs()
        
    }
    
    
    
    func updateThumbs() {
        switch(event.didVote) {
        case -1:
            let img = UIImage(named: "Vote_Red_down")
            thumbsDown.setBackgroundImage(img, for: .normal)
            thumbsUp.isEnabled = false
            thumbsDown.isEnabled = false
            votes.text = String(describing: event.upVote - event.downVote)
        case 1:
            let img = UIImage(named: "Vote_Green_up")
            thumbsUp.setBackgroundImage(img, for: .normal)
            thumbsUp.isEnabled = false
            thumbsDown.isEnabled = false
            votes.text = String(describing: event.upVote - event.downVote)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

