//
//  loginVC.swift
//  tier1
//
//  Created by Justin Maldonado on 4/29/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class loginVC: UIViewController, GIDSignInUIDelegate{
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            print("Not Logged In")
            GIDSignIn.sharedInstance().uiDelegate = self
//            googleLoginButton.colorScheme = GIDSignInButtonColorScheme.dark
    }
    
}