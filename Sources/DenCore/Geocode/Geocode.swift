//
//  GeoCoding.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-28.
//

import Foundation
import CoreLocation

/// The `Geocoder` protocol defines interfaces for reverse geocode a location into a human readable string.
/// - Note: Created for test mock purpose.
public protocol Geocoder {
    /// Check if there is an ongoing reverse geocode request
    var hasOngoingGeocode: Bool { get }
    /// Reverse geocode a location into a human readable string.
    /// - Parameters:
    ///   - location: The location to parse
    ///   - completion: A `CLGeocodeCompletionHandler` block which will be triggered when the reverse geocode request finishes,
    ///   no matter it succeed or failed
    func parseLocation(_ location:CLLocation, completion: @escaping CLGeocodeCompletionHandler)
    /// Cancels the ongoing reverse geocode request
    func cancalOngoingGeocode()
}

extension CLGeocoder: Geocoder {
    public var hasOngoingGeocode: Bool {
        isGeocoding
    }
    
    public func parseLocation(_ location: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        reverseGeocodeLocation(location, completionHandler: completion)
    }
    
    public func cancalOngoingGeocode() {
        cancelGeocode()
    }
}

/// Simulates an antenna dish that is capable to reverse geocode a coordinate into a human readable address
public class AntennaDish {
    /// The internal geocoder object
    internal var geocoder: Geocoder = CLGeocoder()
    
    /// Default no parameter initializer
    public init() {}
    
    /// Reverse geocode a location into a human readable string.
    /// - Parameters:
    ///   - location: The location to parse
    ///   - completion: A `CLGeocodeCompletionHandler` block which will be triggered when the reverse geocode request finishes,
    ///   no matter it succeed or failed
    public func parseLocation(_ location: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void ) {
        if geocoder.hasOngoingGeocode {
            geocoder.cancalOngoingGeocode()
        }
        
        geocoder.parseLocation(location, completion: completion)
    }
}
