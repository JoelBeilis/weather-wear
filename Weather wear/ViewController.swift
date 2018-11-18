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

class ViewController: UIViewController, CLLocationManagerDelegate {
  
    @IBOutlet weak var weatherIcon: UIImageView?
    
    @IBOutlet weak var temperatureLabel: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    @IBOutlet weak var clothingLabel: UILabel?

    let locationManager = CLLocationManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
//            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func celsius(fahrenheit: Double) -> Double {
        return floor((fahrenheit - 32.0) * (5/9))
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
                    
                    DispatchQueue.main.async {
                        
                        print ("Weather icon is \(data.currently?.icon)")
                        print ("Current temperature is \(data.currently?.temperature)")
                        
                        self.temperatureLabel?.text = "\(self.celsius(fahrenheit: (data.currently!.temperature)!)) C"
                        
                        let iconImageNames = [
                            "clear-day" : "sun",
                            "clear-night" : "moon",
                            "rain" : "cloud-rain",
                            "snow" : "cloud-snow",
                            "sleet" : "cloud-drizzle",
                            "wind" : "wind",
                            "fog" : "cloud-fog",
                            "cloudy" : "cloud",
                            "partly-cloudy-day" : "cloud-sun",
                            "partly-cloudy-night" : "cloud-moon",
                            "hail" : "cloud-hail",
                            "thunderstorm" : "cloud-lightning",
                            "tornado" : "tornado"
                         ]
                        
                        let clothingLabelNames = [
                            "clear-day" : "sun gear",
                            "clear-night" : "jacket or sweater",
                            "rain" : " rain gear",
                            "snow" : "snow gear",
                            "sleet" : "jacket, hat, gloves",
                            "wind" : "wind breaker",
                            "fog" : "jacket or sweater",
                            "cloudy" : "jacket or sweater",
                            "partly-cloudy-day" : "jacket or sweater",
                            "partly-cloudy-night" : "jacket or sweater",
                            "hail" : "rain gear",
                            "thunderstorm" : "raincoat, rainboots",
                            "tornado" : "jacket, hat, sweater",
                         ]
                        
                        var curClothingLabel = clothingLabelNames[(data.currently?.icon)!]
                        if ((curClothingLabel == nil) || (curClothingLabel?.isEmpty)!)   {
                          curClothingLabel = "No suggestions to wear"
                        }
                        self.clothingLabel?.text = curClothingLabel
                        
                        var curWeatherIcon = iconImageNames[(data.currently?.icon)!]
                        if (curWeatherIcon!.isEmpty) {
                            curWeatherIcon = "cloud-download"
                        }
                        self.weatherIcon?.image = UIImage(named: curWeatherIcon!)
                        
                        let date = NSDate()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                        self.dateLabel?.text = dateFormatter.string(from: date as Date)
                        
                        self.temperatureLabel?.textAlignment = .center
                        self.dateLabel?.textAlignment = .center
                        self.clothingLabel?.textAlignment = .center
                      
                    }

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

}



