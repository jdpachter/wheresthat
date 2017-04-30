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
            
            googleLoginButton.colorScheme = GIDSignInButtonColorScheme.dark
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
            print("FACEBOOK TOKEN:"+FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                
                if error != nil {
                    // SETP 5. HERE
                    
                    let nsError = (error! as NSError)
                    // Error: 17007 The email address is already in use by another account. ERROR_EMAIL_ALREADY_IN_USE
                    
                    if nsError.code == 17007{
                        
                        
//                        print(error!,(user?.uid)!,nsError.code,"google user error")
                        FBcredentialStorage[(user?.email)!] = credential
                        let email = nsError.userInfo["FIRAuthErrorUserInfoEmailKey"] as? String
                        self.signInUserWithGoogle(email!)
                        print("email",email!)
                    }
                    return
                }
                else{
                    print("Logged in with facebook")
                    FBcredentialStorage[(user?.email)!] = credential
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
    
    
    func linkAccountWithGoogle(_ user: FIRUser){
        let credential = FBcredentialStorage[(user.email)!]
        
        FIRAuth.auth()?.currentUser?.link(with: credential!, completion: { (user:FIRUser?, error:Error?) in
            
            if let LinkedUser = user{
                
                print("NEW USER:",LinkedUser.uid)
                
            }
            
            if let error = error as NSError?{
                
                //Indicates an attempt to link a provider of a type already linked to this account.
                if error.code == FIRAuthErrorCode.errorCodeProviderAlreadyLinked.rawValue{
                    print("FIRAuthErrorCode.errorCodeProviderAlreadyLinked")
                }
                
                //This credential is already associated with a different user account.
                if error.code == 17025{
                    
                }
                
                print("MyError",error)
            }
            
        })
    }
    
    func signInUserWithGoogle(_ email: String){
        if let credential = GOOGLEcredentialStorage[email]{
            print(credential.provider)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if user != nil{
                    
                    self.linkAccountWithGoogle(user!)
                    OperationQueue.main.addOperation {
                        [weak self] in
                        self?.performSegue(withIdentifier: "loggedIn", sender: self)
                    }
                    print((user?.uid)!)
                    
                }else{
                    
                    print((error?.localizedDescription)!)
                }
            }
        }
    }
    
}
