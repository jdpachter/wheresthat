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

class eventPage: UIViewController {
    
    @IBOutlet var eventName : UILabel!
    @IBOutlet var location : UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var type: UILabel!
    
    var event: event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

