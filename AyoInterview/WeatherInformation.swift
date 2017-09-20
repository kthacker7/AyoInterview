//
//  WeatherInformation.swift
//  AyoInterview
//
//  Created by Kunal Thacker on 9/19/17.
//  Copyright © 2017 Kunal Thacker. All rights reserved.
//

import Foundation

class WeatherInformation: NSObject {
    var cityName : String?
    var countryName : String?
    var latitude : Double?
    var longitude : Double?
    var currTemp : Double?
    var minTemp  : Double?
    var maxTemp : Double?
    var humidity : Double?
    var weatherDesc : String?
    var dateText : String?
    var pressure : Double?
    
    func loadInformation(jsonData : [String : Any]) {
        if let name = jsonData["name"] as? String {
            self.cityName = name
        }
        if let sys = jsonData["sys"] as? [String : Any] {
            if let name = sys["country"] as? String {
                self.countryName = name
            }
        }
        if let coordsInfo = jsonData["coord"] as? [String : Double] {
            if let latVal = coordsInfo["lat"] {
                self.latitude = latVal
            }
            if let lonVal = coordsInfo["lon"] {
                self.longitude = lonVal
            }
        }
        if let main = jsonData["main"] as? [String : Double] {
            if let humidty = main["humidity"] {
                self.humidity = humidty
            }
            if let cPressure = main["pressure"] {
                self.pressure = cPressure
            }
            if let cTemp = main["temp"] {
                self.currTemp = cTemp
            }
            if let miTemp = main["temp_min"] {
                self.minTemp = miTemp
            }
            if let maTemp = main["temp_max"] {
                self.maxTemp = maTemp
            }
        }
        if let information = jsonData["weather"] as? [[String : Any]]{
            if information.count > 0 {
                let firstInfo = information[0]
                if let desc = firstInfo["description"] as? String {
                    self.weatherDesc = desc
                }
            }
        }
        if let dt = jsonData["dt"] as? NSNumber {
            let df = DateFormatter()
            let date = Date(timeIntervalSinceReferenceDate: dt.doubleValue)
            df.locale = Locale(identifier: "en_US")
            self.dateText = df.string(from: date)
        }
    }
}
