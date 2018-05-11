//
//  CabUnitManager.swift
//  Cab2GoRider
//
//  Created by Yevhenii on 04.05.2018.
//  Copyright © 2018 Yevhenii. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol CabControllerDelegate {
    func canCallCab(delegateCalled: Bool)
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String)
    func updateDriversLocation(lat: Double, long: Double)
}

class CabUnitManager {
    
    private static let instance = CabUnitManager()
    
    var cabControllerDelegate: CabControllerDelegate?
    
    static var defaultManager: CabUnitManager {
        return instance
    }
    
    var rider = ""
    var driver = ""
    var rider_id = ""
    
    func observeMessagesForRider() {
        //Rider requested a ride
        DatabaseManager.defaultManager.cabRequestReference.observe(.childAdded, with: {(dataSnapshot) in
            
            if let data = dataSnapshot.value as? NSDictionary {
                
                if let name = data[Constants.name] as? String {
                    
                    if name == self.rider {
                        
                        self.rider_id = dataSnapshot.key
                        self.cabControllerDelegate?.canCallCab(delegateCalled: true)
                    }
                    
                }
                
            }
            
        })
        //Driver cancelled a ride
        DatabaseManager.defaultManager.cabRequestReference.observe(.childRemoved, with: {(dataSnapshot) in
            
            if let data = dataSnapshot.value as? NSDictionary {
                
                if let name = data[Constants.name] as? String {
                    
                    if name == self.rider {
                        
                        self.rider_id = dataSnapshot.key
                        self.cabControllerDelegate?.canCallCab(delegateCalled: false)
                    }
                    
                }
                
            }
            
        })
        
        // Driver Updating Location
        
        DatabaseManager.defaultManager.cabRequestAcceptedReference.observe(.childChanged, with: {dataSnapshot in
            
            if let data = dataSnapshot.value as? NSDictionary {
                
                if let name = data[Constants.name] as? String {
                    
                    if name == self.driver {
                        
                        if let lat = data[Constants.latitude] as? Double, let long = data[Constants.longitude] as? Double {
                            
                            self.cabControllerDelegate?.updateDriversLocation(lat: lat, long: long)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
       //Driver accepted a ride
        DatabaseManager.defaultManager.cabRequestAcceptedReference.observe(.childAdded, with: {(dataSnapshot) in
            
            if let data = dataSnapshot.value as? NSDictionary {
                
                if let name = data[Constants.name] as? String {
                    
                    if self.driver == "" {
                        
                        self.driver = name
                        self.cabControllerDelegate?.driverAcceptedRequest(requestAccepted: true, driverName: name)
                        
                    }
                    
                }
                
            }
            
        })
        
        DatabaseManager.defaultManager.cabRequestAcceptedReference.observe(.childRemoved, with: {dataSnapshot in
            
            if let data = dataSnapshot.value as? NSDictionary {
                
                if let name = data[Constants.name] as? String {
                    
                    if name == self.driver {
                        
                        self.driver = ""
                        self.cabControllerDelegate?.driverAcceptedRequest(requestAccepted: false, driverName: name)
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    func requestCab(latitude: Double, longitude: Double) {
        
        let data: [String: Any] = [Constants.name: rider, Constants.latitude: latitude, Constants.longitude: longitude]
        
        DatabaseManager.defaultManager.cabRequestReference.childByAutoId().setValue(data)
    }
    
    func cancelRide() {
        
        DatabaseManager.defaultManager.cabRequestReference.child(rider_id).removeValue()
        
    }
    
    func updateRidersLocation(withLat lat: Double, long: Double) {
        
        DatabaseManager.defaultManager.cabRequestReference.child(rider_id).updateChildValues([Constants.latitude:lat, Constants.longitude:long])
        
    }
    
}
