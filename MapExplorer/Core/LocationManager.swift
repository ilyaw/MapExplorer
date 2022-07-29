//
//  LocationManager.swift
//  MapExplorer
//
//  Created by Ilya on 01.07.2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

protocol LocationManager {
    var location: BehaviorRelay<CLLocation?> { get }
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

final class LocationManagerImpl: NSObject, LocationManager {
    
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        configureLocationManager()
    }
    
    
    func startUpdatingLocation() {
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManagerImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                         locations: [CLLocation]) {
        location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
