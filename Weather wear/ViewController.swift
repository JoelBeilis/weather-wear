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

class ViewController: UIViewController, CLLocationManagerDelegate,  UICollectionViewDataSource  {
    
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
    
    let iconImageLabels = [
        "clear-day" : "Clear Day",
        "clear-night" : "Clear Night",
        "rain" : "Rainy",
        "snow" : "Snowing",
        "sleet" : "Drizzle",
        "wind" : "Windy",
        "fog" : "Foggy",
        "cloudy" : "Cloudy",
        "partly-cloudy-day" : "Cloudy Day",
        "partly-cloudy-night" : "Cloudy Night",
        "hail" : "Hail",
        "thunderstorm" : "Thunderstorm",
        "tornado" : "Tornado"
    ]
    
    let clothingLabelNames = [
        "clear-day" : "Sun gear",
        "clear-night" : "Jacket or sweater",
        "rain" : " Rain gear",
        "snow" : "Snow gear",
        "sleet" : "Jacket, hat, gloves",
        "wind" : "Wind breaker",
        "fog" : "Jacket or sweater",
        "cloudy" : "Jacket or sweater",
        "partly-cloudy-day" : "Jacket or sweater",
        "partly-cloudy-night" : "Jacket or sweater",
        "hail" : "Rain gear",
        "thunderstorm" : "Raincoat, rainboots",
        "tornado" : "Jacket, hat, sweater",
        ]
    
    var darkSkyData : WXKDarkSkyResponse?
    
    var isCelcius : Bool = true
    
    @IBOutlet weak var hourlyWeatherCollection: UICollectionView?
    
    @IBOutlet weak var celsiusToFahrenheitButton: UIButton?
    
    @IBOutlet weak var weatherWearLabel: UILabel?
    
    @IBOutlet weak var iconNameLabel: UILabel?
    
    @IBOutlet weak var weatherIcon: UIImageView?
    
    @IBOutlet weak var temperatureLabel: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    @IBOutlet weak var clothingLabel: UILabel?

    static let locationManager = CLLocationManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // For use when the app is open & in the background
        ViewController.locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        ViewController.locationManager.requestWhenInUseAuthorization()
    
        
        if CLLocationManager.locationServicesEnabled() {
            ViewController.locationManager.delegate = self
            ViewController.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
        }
        
        let cellNib = UINib(nibName: "HourlyWeatherViewControllerCollectionViewCell", bundle: nil)
        self.hourlyWeatherCollection?.register(cellNib, forCellWithReuseIdentifier: "cell")
        
        self.isCelcius = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ViewController.refresh()
    }
    
    static func refresh() {
        if CLLocationManager.locationServicesEnabled() {
            ViewController.locationManager.startUpdatingLocation()
        }
    }
    
    func celsius(fahrenheit: Double) -> Double {
        return floor((fahrenheit - 32.0) * (5/9))
    }
    
    func kph(mph: Float) -> Float {
        return mph * 1.609344
    }
    //if celsiusToFahrenheitButton pushed switch celsius to fahrenheit{
   
    //}
    //else if celsiusToFahrenheitButton pushed switch fahrenheit to celsius{
    
    //}
    
    @IBAction func tempMode() {
        self.isCelcius = !self.isCelcius
        self.update()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.first {
            print(location.coordinate)
            
            ViewController.locationManager.stopUpdatingLocation()
            
            let request = WXKDarkSkyRequest(key: "cf0cf207553849cd5fa3a58e88d4d17e")
            // Location services are available, so query the user’s location.
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
//                    // Cupertino - Apple's office
//                    let latitude = 37.3229978
//                    let longitude = -122.0321823
            

            let point = WXKDarkSkyRequest.Point(latitude, longitude)
            
            request.loadData(point: point) { (data, error) in
                if let error = error {
                    // Handle errors here...
                } else if let data = data {
                    // Handle the received data here...
                    
                    DispatchQueue.main.async {
                        self.darkSkyData = data
                        self.update()
                    }

                }
            }
        }
    }
    
    func getTemp(farenheitTemp : Double) -> String {
        return (self.isCelcius) ?
            "\(Int(self.celsius(fahrenheit: farenheitTemp)))°C" :
            "\(Int(floor(farenheitTemp)))°F"
    }
    
    func update() {
        
        self.weatherWearLabel?.text = ""
        self.celsiusToFahrenheitButton?.setTitle("°C / °F", for:[])
        
        self.temperatureLabel?.text = self.getTemp(farenheitTemp: (self.darkSkyData?.currently!.temperature)!)
        
        var curClothingLabel = self.clothingLabelNames[(self.darkSkyData?.currently?.icon)!]
        if ((curClothingLabel == nil) || (curClothingLabel?.isEmpty)!)   {
            curClothingLabel = "No suggestions to wear"
        }
        self.clothingLabel?.text = curClothingLabel
        
        let curWeatherIcon = self.iconImageNames[(self.darkSkyData?.currently?.icon) ?? "cloud-download"]
        self.weatherIcon?.image = UIImage(named: curWeatherIcon!)
        
        self.iconNameLabel?.text = self.iconImageLabels[(self.darkSkyData?.currently?.icon) ?? "clear-day"]
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        self.dateLabel?.text = dateFormatter.string(from: date as Date)
        
        self.hourlyWeatherCollection?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(self.darkSkyData?.hourly?.data.count ?? 0, 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.hourlyWeatherCollection?.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HourlyWeatherViewControllerCollectionViewCell
        
        if (indexPath.row == 0) {
            cell.timeLabel?.text = "Now"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h a"
            
            let date = self.darkSkyData?.hourly?.data[indexPath.row].time
            cell.timeLabel?.text = dateFormatter.string(from: date!)
        }
        
        var aWeatherIcon = self.iconImageNames[((self.darkSkyData?.hourly?.data[indexPath.row].icon)!)]
        if (aWeatherIcon!.isEmpty) {
            aWeatherIcon = "cloud-download"
        }
        cell.weatherIcon?.image = UIImage(named: aWeatherIcon!)
        cell.temperatureLabel?.text = self.getTemp(farenheitTemp: (self.darkSkyData?.hourly?.data[indexPath.row].temperature)!)
        return cell
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



