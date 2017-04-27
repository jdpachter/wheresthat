//
//  eventCell.swift
//  tier1
//
//  Created by Justin Maldonado on 4/25/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit

class eventCell: UITableViewCell {
    @IBOutlet weak var eventTypeIcon: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet var miles: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        eventTypeIcon.layer.cornerRadius = eventTypeIcon.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
