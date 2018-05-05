//
//  DataBaseManager.swift
//  Cab2GoRider
//
//  This class contain references for database
//
//  Created by Yevhenii on 03.05.2018.
//  Copyright © 2018 Yevhenii. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    private static let instance = DatabaseManager()
    
    static var defaultManager: DatabaseManager {
        return instance
    }
    
    var databaseReference: DatabaseReference {
        return Database.database().reference()
    }
    
    //Riders reference
    var ridersReference: DatabaseReference {
        return databaseReference.child(Constants.riders)
    }
    
    //Request reference
    var cabRequestReference: DatabaseReference {
        return databaseReference.child(Constants.cabRequest)
    }
    //Request accepted reference
    var cabRequestAcceptedReference: DatabaseReference {
        return databaseReference.child(Constants.cabAccepted)
    }
    
    func saveUser(withID id: String, email: String, password: String) {
        let dataDictionary: [String:Any] = [Constants.email:email, Constants.password:password, Constants.isRider:true]
        
        ridersReference.child(id).child(Constants.data).setValue(dataDictionary)
    }
    
}
