import UIKit

struct Test: Codable {
  let id: Int
  let dong: String
  let gu: String
  let longitude: String
  let latitude: String
  let address: String
  let distance: Double
}

let url = URL(string: "http://13.125.217.34/location/locate/gps/?latitude=37.54474309407889&longitude=127.05748842142488")
URLSession.shared.dataTask(with: url!) { (data, response, error) in
  if let error = error { print(error.localizedDescription) }
  else {
    if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
      if let data = data, let testData = try? JSONDecoder().decode([Test].self, from: data) {
        testData.forEach { print($0) }
      }
    }
  }
}.resume()
