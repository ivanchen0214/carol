import UIKit

extension Double {
  func round(to places: Int) -> Double {
    let percisionNumber = pow(10, Double(places))
    var n = self
    n = n * percisionNumber
    n.round()
    n = n / percisionNumber

    return n
  }
}

var myDouble = 3.123456789
myDouble.round(to: 5)
