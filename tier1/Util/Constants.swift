//
//  Constants.swift
//  tier1
//
//  Created by Justin Maldonado on 4/25/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import GoogleSignIn
import Firebase

let SHADOW_COLOR: CGFloat = 130.0/255.0
let LIGHT_BLUE = UIColor(red: 207/255, green: 226/255, blue: 243/255, alpha: 0)
let DARK_BLUE = UIColor(red: 113/255, green: 169/255, blue: 198/255, alpha: 0)
let typeOpts = ["Free Stuff", "Social Event", "Campus Event", "Study Group", "Public Safety"]
var FBcredentialStorage: [String: FIRAuthCredential] = [:]
var GOOGLEcredentialStorage: [String: FIRAuthCredential] = [:]
var GOOGLEidTokenStorage: [String: String] = [:]
var GOOGLEtokenStorage: [String: String] = [:]

func findCurrentViewController(_ vc: UIViewController) -> UIViewController{
    if vc.presentedViewController != nil{
        return findCurrentViewController(vc.presentedViewController!)
    }
    else if vc is UINavigationController {
        let svc = vc as! UINavigationController
        if (svc.viewControllers.count > 0){
            return findCurrentViewController(svc.topViewController!)
        }
        else{
            return vc
        }
    }
    else if vc is UITabBarController{
        let svc = vc as! UITabBarController
        if ((svc.viewControllers?.count)! > 0){
            return findCurrentViewController(svc.selectedViewController!)
        }
        else{
            return vc
        }
    }
    else{
        return vc
    }
}

func currentViewController() -> UIViewController{
    let viewController = UIApplication.shared.keyWindow?.rootViewController
    return findCurrentViewController(viewController!)
}
