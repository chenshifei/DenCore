//
//  Network.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-28.
//

import Foundation

public enum NetworkCableError: Error {
    case HTTPStatusCodeError(Int)
    case InvalidURL(String)
    case EmptyData
    case Other(String)
}

protocol NetworkSession {
    func get(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func get(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
}

public class NetworkCable {
    internal var session: NetworkSession = URLSession()
    
    public func fetchData<T: Codable>(from url: URL, completion: @escaping (T?, Error?) -> Void) {
        session.get(from: url, completion: { data, response, error in
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else {
                    completion(nil, NetworkCableError.HTTPStatusCodeError(response.statusCode))
                    return
                }
                
                guard let data = data else {
                    completion(nil, NetworkCableError.EmptyData)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result, nil)
                    return
                } catch {
                    completion(nil, error)
                    return
                }
            } else {
                completion(nil, error)
            }
        })
    }
}
