//
//  DefaultEndpoints.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-29.
//

import Foundation

public struct DefaultEndpoints {
    static let cable = NetworkCable()
    
    public struct Currency {
        static let host = "api.coinbase.com"
        static let scheme = "https"
        
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
