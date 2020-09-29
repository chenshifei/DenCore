//
//  DefaultEndpoints.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-29.
//

import Foundation

/// This struct pre-defines API endpoints for convenience.
public struct DefaultEndpoints {
    static let cable = NetworkCable()
    
    /// Currency related APIs provided by [coinbase.com](coinbase.com)
    public struct Currency {
        static let host = "api.coinbase.com"
        static let scheme = "https"
        
        /// Fetches the latest exchange rates.
        /// - SeeAlso:
        /// [https://developers.coinbase.com/api/v2#exchange-rates](https://developers.coinbase.com/api/v2#exchange-rates)
        /// - Parameters:
        ///   - currency: The currency name which should follow ISO 4217 or similar.
        ///   Default = `"BTC"`
        ///   - completion: A block to be triggered when the request finishes, regardless of success or not. Contains an `ExchangeRates?` object and an `Error?`.
        static public func fetchExchangeRates(currency: String = "BTC", completion: @escaping (ExchangeRates?, Error?) -> Void) {
            var urlComponents = URLComponents()
            urlComponents.host = DefaultEndpoints.Currency.host
            urlComponents.scheme = DefaultEndpoints.Currency.scheme
            urlComponents.path = "/v2/exchange-rates"
            urlComponents.queryItems = [URLQueryItem(name: "currency", value: currency)]
            guard let url = urlComponents.url else {
                return
            }
            
            cable.fetchData(from: url) { result, error in
                completion(result, error)
            }
        }
    }
}
