//
//  MapViewController.swift
//  Cab2GoRider
//
//  Created by Yevhenii on 18.04.2018.
//  Copyright © 2018 Yevhenii. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, CabControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findACabButton: UIButton!
    
    private var locationManager = CLLocationManager()
    
    private var driversLocation: CLLocationCoordinate2D?
    private var ridersLocation: CLLocationCoordinate2D?
    
    private var timer = Timer()
    
    private var canRequestCab = true
    private var riderCancelledRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CabUnitManager.defaultManager.observeMessagesForRider()
        CabUnitManager.defaultManager.cabControllerDelegate = self
        
        mapView.delegate = self
        mapView.layer.cornerRadius = 20
        
        findACabButton.layer.cornerRadius = 10
        
        setLocationManager()
    }
    
    //MARK: - Other Methods
    
    func setLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @objc func updateRidersLocation() {
        
        CabUnitManager.defaultManager.updateRidersLocation(withLat: (ridersLocation?.latitude)!, long: (ridersLocation?.longitude)!)
        
    }
    
    private func alertUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerAction_OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alerAction_OK)
        present(alert, animated: true, completion: nil)
    }
    
    func canCallCab(delegateCalled: Bool) {
        if delegateCalled {
            findACabButton.setTitle("Cancel Ride", for: .normal)
            canRequestCab = false
        } else {
            findACabButton.setTitle("Find A Cab", for: .normal)
        }
    }
    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        
        if !riderCancelledRequest {
            
            if requestAccepted {
                
                alertUser(title: "Ride Accepted", message: "\(driverName) has accepted your ride request")
                
            } else {
                
                CabUnitManager.defaultManager.cancelRide()
                timer.invalidate()
                alertUser(title: "Ride Canceled", message: "\(driverName) canceled the ride")
                
            }
            
        }
        riderCancelledRequest = false
    }
    
    func updateDriversLocation(lat: Double, long: Double) {
        driversLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    //MARK: - Actions
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        if UsersAuthorizationManager.authManager.logOut() {
            
            if !canRequestCab {
                
                CabUnitManager.defaultManager.cancelRide()
                timer.invalidate()
                
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            
            alertUser(title: "Problem signing out", message: "Please, try again later")
            
        }
    }
    
    @IBAction func findACabButtonPressed(_ sender: UIButton) {
        if ridersLocation != nil {
            
            if canRequestCab {
                
              CabUnitManager.defaultManager.requestCab(latitude: Double((ridersLocation?.latitude)!), longitude: Double((ridersLocation?.longitude)!))
                
                timer = Timer.scheduledTimer(timeInterval: 5,
                                             target: self,
                                             selector: #selector(MapViewController.updateRidersLocation),
                                             userInfo: nil,
                                             repeats: true)
                
            } else {
                
                riderCancelledRequest = true
                //cancel ride
                CabUnitManager.defaultManager.cancelRide()
                timer.invalidate()
            }

        } else {
            alertUser(title: "Cab Requesting Error", message: "Cannot determine your current location")
        }
    }
    
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let coordinate = locationManager.location?.coordinate {
            
            ridersLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            if driversLocation != nil {
                
                if !canRequestCab {
                    
                    let driverAnnotation = MKPointAnnotation()
                    driverAnnotation.coordinate = driversLocation!
                    driverAnnotation.title = "Driver Location"
                    mapView.addAnnotation(driverAnnotation)
                }
                
            }
            
            let region = MKCoordinateRegion(center: ridersLocation!,
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
        }
    }
    
}
