//
//  HoveringSubview.swift
//  tier1
//
//  Created by Justin Maldonado on 4/26/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit

class HoveringSubview: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 0.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.85
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
//        layer.shouldRasterize = true
    }

}
