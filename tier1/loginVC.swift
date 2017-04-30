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

class loginVC: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate{
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = FIRAuth.auth()?.currentUser{
            print("Logged In")
            OperationQueue.main.addOperation {
                [weak self] in
                self?.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        }
        else{
            print("Not Logged In")
            fbLoginButton.readPermissions = ["public_profile","email"]
            fbLoginButton.delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
        }
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print("LOGIN ERROR")
            print(error.localizedDescription)
            return
        }
        else{
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("SUCCESSFUL LOGIN")
            print(credential)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                else{
                    print("Logged in with facebook")
                    OperationQueue.main.addOperation {
                        [weak self] in
                        self?.performSegue(withIdentifier: "loggedIn", sender: self)
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}
