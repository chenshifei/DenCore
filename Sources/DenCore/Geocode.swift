//
//  GeoCoding.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-28.
//

import Foundation
import CoreLocation

public protocol Geocoder {
    var hasOngoingGeocode: Bool { get }
    func parseLocation(_ location:CLLocation, completion: @escaping CLGeocodeCompletionHandler)
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

public class AntennaDish {
    internal var geocoder: Geocoder = CLGeocoder()
    
    public func parseLocation(_ location: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void ) {
        if geocoder.hasOngoingGeocode {
            geocoder.cancalOngoingGeocode()
        }
        
        geocoder.parseLocation(location, completion: completion)
    }
}
