//
//  Network.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-28.
//

import Foundation

/// Defines several errors that could occur when doing network requests
/// - Note: Invalid URL (e.g. empty URL or URL contains unescaped charactors) is not included,
/// as they should be handeled in the caller by design.
public enum NetworkCableError: Error {
    /// When the HTTP status code isn't 200. The actual code is in the associated value.
    case HTTPStatusCodeError(Int)
    /// When the server returned no data but the status code is 200.
    case EmptyData
    /// Other reasons (e.g. no network due to lack of network access premission on some iPhone models in China).
    /// The detailed reason can be found in the associated value.
    case Other(String)
}

/// Protocol for interchangeable URLSession object
/// - Note: Created for test purposes.
public protocol NetworkSession {
    /// Retrive data from a URL using the HTTP `GET` method.
    /// - Parameters:
    ///   - url: The URL to be fetched
    ///   - completion: A block called when the request is finished, no matter it's successful or not.
    func get(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    public func get(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
}

/// A network cable through which you connect to the internet.
public class NetworkCable {
    internal var session: NetworkSession = URLSession()
    
    /// Retrive data from a URL using the HTTP `GET` method.
    /// - Parameters:
    ///   - url: The URL to be fetched
    ///   - completion: A block called when the request is finished, no matter it's successful or not.
    public func fetchData<T: Codable>(from url: URL, completion: @escaping (T?, Error?) -> Void) {
        session.get(from: url, completion: { data, response, error in
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else {
                    // Redirection and other codes that aren't really a failure are not included yet.
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
                // Non HTTP requests are not included yet.
                completion(nil, error)
            }
        })
    }
}
