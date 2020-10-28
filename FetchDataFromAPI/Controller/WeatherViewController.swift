//
//  ViewController.swift
//  FetchDataFromAPI
//
//  Created by chen Ivan on 2020/10/14.
//

import UIKit
import CoreLocation
import CLTypingLabel

class WeatherViewController: UIViewController {
  @IBOutlet weak var titleLabel: CLTypingLabel!
  @IBOutlet weak var cityField: UITextField!

  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
    
    cityField.delegate = self
    weatherManager.delegate = self
    
    titleLabel.text = "?"
  }

  @IBAction func fetchWeathByCity(_ sender: UIButton) {
    if let city = cityField.text {
      weatherManager.fetch(byCity: city)
    }
  }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude

      weatherManager.fetch(latitude: lat, longitude: lon)
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    cityField.text = ""
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let city = cityField.text {
      weatherManager.fetch(byCity: city)
    }

    cityField.endEditing(true)
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if cityField.text != "" {
      return true
    } else {
      return false
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
  }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
    DispatchQueue.main.async {
      self.titleLabel.text = weather.name
    }
  }

  func didFailWithError(error: Error) {
    print(error)
  }
}
