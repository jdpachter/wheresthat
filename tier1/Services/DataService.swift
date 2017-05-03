//
//  DataService.swift
//  tier1
//
//  Created by Justin Maldonado on 5/2/17.
//  Copyright © 2017 Joshua Pachter. All rights reserved.
//

import Foundation
import Firebase

let BASE = FIRDatabase.database()


class DataService{
    static let ds = DataService()
    
    private var _REF_BASE = BASE.reference()
    private var _REF_EVENTS = BASE.reference().child("events-v4")
    private var _REF_USERS = BASE.reference().child("users")
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_EVENTS: FIRDatabaseReference{
        return _REF_EVENTS
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference{
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
        let user = REF_USERS.child(uid)
        return user
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>){
        REF_USERS.child(uid).setValue(user)
    }
}
