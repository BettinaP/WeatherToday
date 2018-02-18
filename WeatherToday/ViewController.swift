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
                if error != nil {
                    print(error)
                    DispatchQueue.main.sync(execute: {
                        self.locationNameLabel.text = "Error: Weather could not be found. Please try again."
                    })
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        print(dataString)
                    }
                    print(response)
                }
            })
            task.resume()
        }
        
    }
    
    
}
