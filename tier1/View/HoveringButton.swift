//
//  HoveringButton.swift
//  tier1
//
//  Created by Justin Maldonado on 4/25/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit

class HoveringButton: UIButton {
        
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
}
