//
//  CabUnitManager.swift
//  Cab2GoRider
//
//  Created by Yevhenii on 04.05.2018.
//  Copyright © 2018 Yevhenii. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CabUnitManager {
    
    private static let instance = CabUnitManager()
    
    static var defaultManager: CabUnitManager {
        return instance
    }
    
    var rider = ""
    var driver = ""
    var rider_id = ""
    
    func requestCab(latitude: Double, longitude: Double) {
        
        let data: [String: Any] = [Constants.name: rider, Constants.latitude: latitude, Constants.longitude: longitude]
        
        DatabaseManager.defaultManager.cabRequestReference.childByAutoId().setValue(data)
    }
    
}
