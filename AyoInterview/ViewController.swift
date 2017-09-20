//
//  ViewController.swift
//  AyoInterview
//
//  Created by Kunal Thacker on 9/19/17.
//  Copyright © 2017 Kunal Thacker. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let manager: CLLocationManager = CLLocationManager.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupLocation()
        self.mapView.delegate = self
        self.setupDoubleTap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDoubleTap() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleDoubleTap(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.delegate = self
        self.mapView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        print("Got double tap")
        let point = gesture.location(in: self.mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: self.view)
        print("Lat = \(coordinate.latitude), long = \(coordinate.longitude)")
        let storyboard = UIStoryboard.init(name: "Main", bundle:nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherDataViewController") as? WeatherDataViewController {
            vc.latitude = coordinate.latitude
            vc.longitude = coordinate.longitude
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func setupLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.mapView.showsUserLocation = true
        } else {
            self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region.center = userLocation.coordinate
        region.span.latitudeDelta = 0.15
        region.span.longitudeDelta = 0.15
        mapView.setRegion(region, animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

