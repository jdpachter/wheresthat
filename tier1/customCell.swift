//
//  customCell.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import Foundation

class customCell : UITableViewCell {
    

    @IBOutlet var desc: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var img: UIImageView!
    

    
    func updateLabels() {
        
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        desc.font = bodyFont
        
        let caption1Font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        type.font = caption1Font
        
        
    }
}
