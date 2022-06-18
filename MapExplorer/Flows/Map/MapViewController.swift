//
//  MapViewController.swift
//  MapExplorer
//
//  Created by Ilya on 15.05.2022.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var marker: GMSMarker?
    var geoCoder: CLGeocoder?
    var locationManager: CLLocationManager?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    let coordinate = CLLocationCoordinate2D(latitude: 64.540643163229,
                                            longitude: 39.805884020953464)
    
    override func loadView() {
//        view = 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
        
        updateLocation()
    }
    
    // MARK: - Private methods
    
    func updateLocation() {
        locationManager?.requestLocation()
        
        route?.map = nil
        
        route = GMSPolyline()
        routePath = GMSMutablePath()
        
        route?.map = mapView
        
        locationManager?.startUpdatingLocation()
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        mapView.delegate = self
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    private func addMarker() {
        marker = GMSMarker(position: coordinate)
        marker?.map = mapView
        
        marker?.title = "Заголовок"
        marker?.snippet = "Сниппет"
    }
    
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
}

extension MapViewController: GMSMapViewDelegate {
    //Получаем координаты куда нажали
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let manualMarker = GMSMarker(position: coordinate)
        manualMarker.map = mapView
        
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        
        geoCoder?.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { places, error in
            // Выводит информацию (название улицы, адрес итд)
            print(places?.last)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    // Получает данные по мере того как наш объект двигается по карте
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        routePath?.add(location.coordinate)
        route?.path = routePath
        
//        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        mapView.animate(toLocation: location.coordinate)
        
        marker = GMSMarker(position: location.coordinate)
        marker?.map = mapView
        marker?.title = "Координаты"
        marker?.snippet = "\(location.coordinate.longitude) \(location.coordinate.latitude)"
        
        print(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
    
