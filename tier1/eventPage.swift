//
//  eventPage.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import MapKit

class eventPage: UIViewController {
    
    var model: Model!
    
    @IBOutlet var eventName : UILabel!
    @IBOutlet var location : UILabel!
    @IBOutlet var time: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventName.text = model.allEvents[0].desc
        location.text = model.allEvents[0].location
        time.text = String(describing: model.allEvents[0].eventTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

