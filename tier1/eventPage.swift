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
    
    var event: event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventName.text = event.desc
        location.text = event.location
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: event.eventTime as Date)
        time.text = strDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

