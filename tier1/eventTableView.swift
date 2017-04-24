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
    
    var curEvent: event!
    
    override func viewDidLoad() {
        self.tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(eventTableView.unblur), name:NSNotification.Name(rawValue: "unblur"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.allEvents.count
    }
    
    func unblur() {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventPageT" {
            if let eventPage = segue.destination as? eventPage {
                eventPage.event = curEvent
            }
        }
        else if segue.identifier == "newFromTV" {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            
        }
        
    }
    
    /*func getTableCell(_ path: IndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: path) as! customCell
        
        cell.updateLabels()

        let current = model.allEvents[path.row]
        cell.desc?.text = current.desc
        cell.type?.text = model.typeToString(current.type)
        if let im = current.getImg(false) {
            cell.img?.image = UIImage(named: im)
        }
        return cell
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let e = self.model.lookupEvent(byCoordinate: (model.allEvents[indexPath.row].coordinate)) {
            curEvent = e
        }
        performSegue(withIdentifier: "toEventPageT", sender: self.view)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        let eventName = model.allEvents[indexPath.row].desc
        let eventType = model.typeToString(model.allEvents[indexPath.row].type)
        cell.textLabel?.text = eventName
        cell.detailTextLabel?.text = eventType
//        cell.textLabel?.textColor = model.typeToColor(model.allEvents[indexPath.row].type)
        return cell
    }
}
