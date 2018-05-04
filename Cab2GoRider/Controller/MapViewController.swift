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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findACabButton: UIButton!
    
    private var locationManager = CLLocationManager()
    
    private var driversLocation: CLLocationCoordinate2D?
    private var ridersLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
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
    
    private func alertUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alerAction_OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alerAction_OK)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        if UsersAuthorizationManager.authManager.logOut() {
            dismiss(animated: true, completion: nil)
        } else {
            
            alertUser(title: "Problem signing out", message: "Please, try again later")
            
        }
    }
    
    @IBAction func findACabButtonPressed(_ sender: UIButton) {
    }
    
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
}
