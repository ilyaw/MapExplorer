//
//  MapViewController.swift
//  MapExplorer
//
//  Created by Ilya on 15.05.2022.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
        
    // MARK: - Private properties
    
    private var marker: GMSMarker?
    private var geoCoder: CLGeocoder?
    private var locationManager: CLLocationManager?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    // Дефолтные координаты
    private let coordinate = CLLocationCoordinate2D(latitude: 64.540643163229,
                                            longitude: 39.805884020953464)
    
    private let customView = MapView(frame: UIScreen.main.bounds)
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = customView
        customView.setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
        updateLocation()
    }
    
    // MARK: - Private methods
    
    private func updateLocation() {
        locationManager?.requestLocation()
        
        route?.map = nil
        
        route = GMSPolyline()
        routePath = GMSMutablePath()
        
        route?.map = customView.mapView
        
        locationManager?.startUpdatingLocation()
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        customView.mapView.camera = camera
        customView.mapView.isMyLocationEnabled = true
        customView.mapView.delegate = self
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    // Добавляет маркер на карту с описанием
    private func addMarker() {
        marker = GMSMarker(position: coordinate)
        marker?.map = customView.mapView
        
        marker?.title = "Заголовок"
        marker?.snippet = "Сниппет"
    }
    
    // Удаляет маркер
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
}

// MARK: - MapViewController + GMSMapViewDelegate

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

// MARK: - MapViewController + CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    // Получает данные по мере того как наш объект двигается по карте
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        routePath?.add(location.coordinate)
        route?.path = routePath
        
//        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        customView.mapView.animate(toLocation: location.coordinate)
        
        marker = GMSMarker(position: location.coordinate)
        marker?.map = customView.mapView
        marker?.title = "Координаты"
        marker?.snippet = "\(location.coordinate.longitude) \(location.coordinate.latitude)"
        

        print(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
    
