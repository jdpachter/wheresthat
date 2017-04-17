//
//  eventTableView.swift
//  tier1
//
//  Created by Joshua Pachter on 4/17/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import Foundation
import UIKit

class eventTableView: UITableViewController {
    
    var model: Model!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.allEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        let eventName = model.allEvents[indexPath.row].desc
        let eventType = model.typeToString(model.allEvents[indexPath.row].type)
        cell.textLabel?.text = eventName
        cell.detailTextLabel?.text = eventType
        cell.textLabel?.textColor = model.typeToColor(model.allEvents[indexPath.row].type)
        return cell
    }
}
