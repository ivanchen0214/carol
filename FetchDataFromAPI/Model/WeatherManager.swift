import Foundation
import CoreLocation
import Alamofire

protocol WeatherManagerDelegate {
  //看起來更像apple希望的format
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let url: String = "https://api.openweathermap.org/data/2.5/weather?appid=%@"
  let apiKey: String = ""
  var delegate: WeatherManagerDelegate?
  
  init() {
  }
  
  func fetch(byCity cityName: String) {
    var fullUrl = "\(url)&q=%@"
    let city = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? cityName
    
    fullUrl = String(format: fullUrl, apiKey, city)
    
    AF.request(fullUrl).responseJSON { response in
      switch response.result {
      case .success:
        if let jsonData = response.data {
          if let weather = self.parseJSON(jsonData) {
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func fetch(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    var fullUrl = "\(url)"
    fullUrl = String(format: fullUrl, apiKey)
    fullUrl += "&lat=\(latitude)&lon=\(longitude)"
    
    AF.request(fullUrl).responseJSON { response in
      switch response.result {
      case .success:
        if let jsonData = response.data {
          if let weather = self.parseJSON(jsonData) {
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    
    do {
      let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
      let weather = WeatherModel(name: decodeData.name)
      return weather
    } catch {
      self.delegate?.didFailWithError(error: error)
      return nil
    }
  }
}
