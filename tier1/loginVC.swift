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

class loginVC: UIViewController, FBSDKLoginButtonDelegate{
    @IBOutlet weak var loginView: UIView!
    var fbLoginButton: FBSDKLoginButton!
//    @IBOutlet weak var fbLoginButton: UIButton!
    
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
//            fbLoginButton.addTarget(self, action: #selector(pressedFBLogin(_:)), for: UIControlEvents.touchUpInside)
            fbLoginButton = FBSDKLoginButton()
            fbLoginButton.readPermissions = ["public_profile","email"]
            fbLoginButton.delegate = self
            fbLoginButton.center = loginView.center
            loginView.addSubview(fbLoginButton)
            loginView.translatesAutoresizingMaskIntoConstraints = false
            fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        }
        
//        googleLoginButton.addTarget(self, action: #selector(googleLoginClicked(_:)), for: UIControlEvents.touchUpInside)
    }
    
//    func pressedFBLogin(_ sender: Any){
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self, handler: {(result, error) -> Void in
//            if (error == nil){
//                let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                if fbloginresult.grantedPermissions != nil {
//                    if(fbloginresult.grantedPermissions.contains("email"))
//                    {
//                        self.getFBUserData()
//                    }
//                }
//            }
//        })
//    }
//    
//    func getFBUserData(){
//        if((FBSDKAccessToken.current()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                    //everything works print the user data
//                    print(result!)
//                }
//            })
//        }
//    }
    
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
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
//    func googleLoginClicked(_ sender: Any){
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
//    }
}
