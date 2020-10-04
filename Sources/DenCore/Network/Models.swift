// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let exchangeRates = try? newJSONDecoder().decode(ExchangeRates.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.exchangeRatesTask(with: url) { exchangeRates, response, error in
//     if let exchangeRates = exchangeRates {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - ExchangeRates
public struct ExchangeRates: Codable {
    public let data: DataClass
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.dataClassTask(with: url) { dataClass, response, error in
//     if let dataClass = dataClass {
//       ...
//     }
//   }
//   task.resume()

// MARK: - DataClass
public struct DataClass: Codable {
    public let currency: String
    public let rates: [String: String]
}
