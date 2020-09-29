//
//  Network.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-28.
//

import Foundation

public class NetworkCable {
    public func fetchData(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "https://api.coinbase.com/v2/exchange-rates?currency=BTC") else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
