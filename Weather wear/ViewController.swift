//
//  ViewController.swift
//  Weather wear
//
//  Created by Joel Beilis on 2018-09-23.
//  Copyright © 2018 Joel Beilis. All rights reserved.
//

import UIKit
import CoreLocation
import WXKDarkSky

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func celsius(fahrenheit: Float) -> Float {
        return (fahrenheit - 32.0) * (5/9)
    }
    
    func kph(mph: Float) -> Float {
        return mph * 1.609344
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.first {
            print(location.coordinate)
            
            locationManager.stopUpdatingLocation()
            
            let request = WXKDarkSkyRequest(key: "cf0cf207553849cd5fa3a58e88d4d17e")
            let point = WXKDarkSkyRequest.Point(location.coordinate.latitude, location.coordinate.longitude)
            
            request.loadData(point: point) { (data, error) in
                if let error = error {
                    // Handle errors here...
                } else if let data = data {
                    // Handle the received data here...
                    print ("Weather icon is \(data.currently?.icon)")
                    print ("Current temperature is \(data.currently?.temperature)")
                }
            }
        }
    }
    
//    func lookUpCurrentLocation() {
//        // Use the last reported location.
//        if let lastLocation = self.locationManager.location {
//            let geocoder = CLGeocoder()
//            
//            // Look up the location and pass it to the completion handler
//            geocoder.reverseGeocodeLocation(lastLocation,
//                                            completionHandler: { (placemarks, error) in
//                                                if error == nil {
//                                                    let firstLocation = placemarks?[0]
//                                                    print(firstLocation?.country)
//                                                }
//            })
//        }
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    }



