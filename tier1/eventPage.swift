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
    
    var model = Model()
    
    @IBOutlet var eventName : UILabel!
    @IBOutlet var location : UILabel!
    @IBOutlet var details : UILabel!
    @IBOutlet var time: UILabel!
    
    @IBOutlet var back: UIButton!
    @IBAction func goBack() {
        performSegue(withIdentifier: "backTo", sender: view)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        eventName.text = model.allEvents[0].name
//        location.text = model.allEvents[0].location
//        details.text = model.allEvents[0].details
//        time.text = String(describing: model.allEvents[0].eventTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

