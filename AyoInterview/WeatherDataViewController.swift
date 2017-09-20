//
//  WeatherDataViewController.swift
//  AyoInterview
//
//  Created by Kunal Thacker on 9/19/17.
//  Copyright © 2017 Kunal Thacker. All rights reserved.
//

import UIKit

class WeatherDataViewController: UIViewController {

    var latitude: Double?
    var longitude: Double?
    
    let apiKey = "243724beac341da771e09e85978d17ef"
    
    @IBOutlet weak var dateDescLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var coordsInfoLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.activityIndicator.isHidden = true
        self.navigationItem.title = "Weather Information"
        self.loadData()
    }

    func getURL() -> URL? {
        if self.latitude != nil && self.longitude != nil {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude!)&lon=\(self.longitude!)&units=imperial&APPID=\(self.apiKey)"
            return URL(string: urlString)
        }
        return nil
    }
    
    func loadData() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if let url = self.getURL() {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                if (error != nil) {
                    let alert = UIAlertController(title: "OOPS!", message: "Your internet does not seem to be working, please try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if (data != nil) {
                        let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                        if (jsonData != nil && jsonData! != nil) {
                            let weatherInformation = WeatherInformation()
                            weatherInformation.loadInformation(jsonData: jsonData!!)
                            self.setupUI(info: weatherInformation)
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    func setupUI(info: WeatherInformation) {
        DispatchQueue.main.async {
            var cityText = ""
            if (info.cityName != nil) {
                cityText = cityText + info.cityName!
            }
            if (info.countryName != nil) {
                cityText = cityText + " " + info.countryName!
            }
            self.locationLabel.text = cityText
            
            if (info.currTemp != nil) {
                self.tempLabel.text = "\(info.currTemp!) °F"
            }
            if (info.minTemp != nil) {
                self.minTempLabel.text = "\(info.minTemp!) °F"
            }
            if (info.maxTemp != nil) {
                self.maxTempLabel.text = "\(info.maxTemp!) °F"
            }
            if (info.dateText != nil) {
                self.dateDescLabel.text = info.dateText!
            }
            if (info.weatherDesc != nil) {
                self.weatherDescLabel.text = "Description : " + (info.weatherDesc!.capitalized)
            }
            if (info.humidity != nil) {
                self.humidityLabel.text = "\(info.humidity!)%"
            }
            if (info.pressure != nil) {
                self.pressureLabel.text = "\(info.pressure!)"
            }
            if (info.latitude != nil && info.longitude != nil) {
                self.coordsInfoLabel.text = "Latitude, longitude = (\(info.latitude!), \(info.longitude!))"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
