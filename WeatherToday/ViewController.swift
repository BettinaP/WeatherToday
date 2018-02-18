//
//  ViewController.swift
//  WeatherToday
//
//  Created by Bettina on 2/17/18.
//  Copyright © 2018 Bettina Prophete. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var weatherSummaryLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    var city = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if cityTextField.text?.isEmpty == true {
            locationNameLabel.text = "Weather could not be found. Please try again."
        } else {
            if var cityText = cityTextField.text {
                if cityText.contains(" ") {
                    
                    city = cityText.capitalized.replacingOccurrences(of: " ", with: "-")
                    locationNameLabel.text = city.replacingOccurrences(of: "-", with: " ")
                } else {
                    city = cityText.capitalized
                    locationNameLabel.text = city
                }
            }
        }
        
        let urlString = "https://www.weather-forecast.com/locations/\(city)/forecasts/latest"
        if let url = URL(string: urlString) {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
                var weatherSummary = ""
                
                if error != nil {
                    print("****error:\(error!.localizedDescription)")
                    DispatchQueue.main.sync(execute: {
                        weatherSummary = "Error: Location or weather could not be found. Please try again."
                        self.weatherSummaryLabel.text = weatherSummary
                    })
                } else if (response as? HTTPURLResponse)?.statusCode  == 404 {
                    DispatchQueue.main.sync(execute: {
                        weatherSummary = "Error: Location could not be found. Please try again."
                        self.weatherSummaryLabel.text = weatherSummary
                    })
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        //Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">Moderate rain (total 18mm), heaviest on Sat night. Very mild (max 16&deg;C on Tue morning, min 3&deg;C on Sat night). Winds decreasing (strong winds from the NW on Sat night, calm by Sun night).</span>
                        let bForecastString = "\"b-forecast__table-description-content\""
                        let phrase = "\"phrase\""
                        var stringSeparator = "Weather Today </h2>(1&ndash;3 days)</span><p class=\(bForecastString)><span class=\(phrase)>"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            //if bad url or source code changes and string separator isn't found so single item in contentArray.
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    weatherSummary = newContentArray[0].replacingOccurrences(of: "&deg;", with: "º")
                                } else {
                                    weatherSummary = "Error: Weather summary could not be found. Please try again."
                                    
                                }
                                DispatchQueue.main.sync(execute: {
                                    self.weatherSummaryLabel.backgroundColor = .white
                                    self.weatherSummaryLabel.text = weatherSummary
                                })
                                
                            }
                            
                        }
                    }
                }
                
            })
            
            task.resume()
        }
        
    }
    
    
}
