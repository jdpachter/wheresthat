//
//  AppDelegate.swift
//  tier1
//
//  Created by Joshua Pachter on 4/1/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GoogleSignIn
import Firebase
import Instabug
import FBSDKCoreKit
import FBSDKLoginKit
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager?


    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //changed some syntax to supress warnings
        if (error) != nil {
            print("\(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print("GOOGLE TOKEN:"+authentication.idToken)
        print(user.userID)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            //changed some syntax to supress warnings pt2
            
            if error != nil {
                print("\(String(describing: error))")
                
                let nsError = (error! as NSError)
                // Error: 17007 The email address is already in use by another account. ERROR_EMAIL_ALREADY_IN_USE
                
                if nsError.code == 17007{
                    let email = nsError.userInfo["FIRAuthErrorUserInfoEmailKey"] as? String
                    self.signInUserWithFacebook(email!)
                    print("email",email!)
                    GOOGLEcredentialStorage[(user?.email)!] = credential
                    GOOGLEidTokenStorage[(user?.email)!] = authentication.idToken
                    GOOGLEtokenStorage[(user?.email)!] = authentication.accessToken
                }
                
                return
            }
            else{
                OperationQueue.main.addOperation {
                    [weak self] in
                    self?.window?.rootViewController?.performSegue(withIdentifier: "loggedIn", sender: nil)
                }
                GOOGLEcredentialStorage[(user?.email)!] = credential
                GOOGLEidTokenStorage[(user?.email)!] = authentication.idToken
                GOOGLEtokenStorage[(user?.email)!] = authentication.accessToken
            }
        }
    }
    
    func signInUserWithFacebook(_ email: String){
        if let credential = FBcredentialStorage[email]{
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if user != nil{
                    
                    self.linkAccountWithFacebook(user!)
                    print((user?.uid)!)
                
                }else{
                
                    print((error?.localizedDescription)!)
                }
            }
        }
    }
    
    func linkAccountWithFacebook(_ user: FIRUser){
        let credential = GOOGLEcredentialStorage[user.email!]
//        let idToken = GOOGLEidTokenStorage[user.email!]
//        let tok = GOOGLEtokenStorage[user.email!]
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
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            OperationQueue.main.addOperation {
                [weak self] in
                self?.window?.rootViewController?.performSegue(withIdentifier: "logOut", sender: nil)
            }
            print("logout")
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        FIRApp.configure()
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        Instabug.start(withToken: "21627bc83189e04364fac72ca2881abd", invocationEvent: .shake)

        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("URL SCHEME:" + url.scheme!)
        if url.scheme == "fb309917576105536"{
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else if url.scheme == "com.googleusercontent.apps.917894496812-affgl3lrakq5ovbvf42cemnt2qtkvsse"{
            print("In google url scheme")
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else{
            return false
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "tier1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

