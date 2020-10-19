import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  //看起來更像apple希望的format
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let urlString: String
  var delegate: WeatherManagerDelegate?
  
  init(_ urlString: String) {
    self.urlString = urlString
  }
  
  func fetch(cityName: String) {
    let fullUrl = "\(urlString)&q=\(cityName)"
    print("fullUrl", fullUrl)
    callAPI(fullUrl)
  }

  func fetch(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let fullUrl = "\(urlString)&lat=\(latitude)&lon=\(longitude)"
    print("fullUrl", fullUrl)
    callAPI(fullUrl)
  }

  func callAPI(_ fullUrl: String) {
    if let url = URL(string: fullUrl) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        
        //        if let jsonString = String(data: data!, encoding: .utf8) {
        //          print(jsonString)
        //        }
        
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      }
      
      task.resume()
    }
  }
  
  //- WeatherModel? 是因為可能return nil
  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    
    do {
      let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
      let weather = WeatherModel(name: decodeData.name)
      print(weather)
      return weather
    } catch {
      self.delegate?.didFailWithError(error: error)
      return nil
    }
  }
}
