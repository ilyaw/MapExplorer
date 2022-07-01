//
//  Location.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import Foundation
import RealmSwift
import CoreLocation

/// Координата
class Location: Object {
    @Persisted var latitude: Double
    @Persisted var longitude: Double
        
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
    
    convenience init(location: CLLocationCoordinate2D) {
        self.init()
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}
