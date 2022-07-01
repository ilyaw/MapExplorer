//
//  MapViewController.swift
//  MapExplorer
//
//  Created by Ilya on 15.05.2022.
//

import UIKit
import GoogleMaps
import RealmSwift
import RxSwift
import RxCocoa
import ReactorKit
import RxRelay

protocol MapDelegate: AnyObject {
    func showListRoutes(with routes: [Route])
}

/// Экран с картой (главная страница)
class MapViewController: UIViewController, View {
    
    weak var delegate: MapDelegate?
    
    var disposeBag = DisposeBag()
    
    // MARK: - Private properties
    
    private var marker: GMSMarker?
    private var geoCoder: CLGeocoder?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private let locationManager: LocationManager
    
    // Дефолтные координаты
    private let coordinate = CLLocationCoordinate2D(latitude: 64.540643163229,
                                                    longitude: 39.805884020953464)
    
    private let customView = MapView(frame: UIScreen.main.bounds)

    private var userRoute: Route?
    private let viewModel: MapViewModel
    
    init(viewModel: MapViewModel, locationManager: LocationManager) {
        self.viewModel = viewModel
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = customView
        customView.setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor = viewModel
        configureMap()
    }
    
    // MARK: - Public methods
    
    /// Биндинг
    func bind(reactor: MapViewModel) {
        
        // Подписка на изменение локации пользователя
        locationManager.location
            .asObservable()
            .compactMap { $0 }
            .bind { [unowned self] currentLocation in
                routePath?.add(currentLocation.coordinate)
                route?.path = routePath
                
                customView.mapView.animate(toLocation: currentLocation.coordinate)
                
                routePath?.add(currentLocation.coordinate)
                let polyline = GMSPolyline(path: routePath)
                polyline.strokeWidth = 10
                polyline.strokeColor = .red
                polyline.map = customView.mapView
                
                userRoute?.locations.append(Location(location: currentLocation.coordinate))
            }
            .disposed(by: disposeBag)
        
        // Тап по кнопке старт
        customView.startButton.rx.tap
            .map { Reactor.Action.startRoute }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Тап по кнопке стоп
        customView.stopButton.rx.tap
            .map { Reactor.Action.stopRoute }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Тап по кнопке открытия маршрутов
        customView.openRoutesButton.rx.tap
            .map { Reactor.Action.openListRoutes }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Признак состояния движения
        reactor.state
            .map { $0.isActiveMovement }
            .distinctUntilChanged()
            .skip(1)
            .bind(onNext: { [weak self] isActiveMovement in
                guard let self = self else { return }
                if isActiveMovement {
                    self.customView.setStop()
                    self.start()
                } else {
                    self.stop()
                    self.viewModel.action.onNext(.saveRoutes(self.userRoute))
                }
            })
            .disposed(by: disposeBag)
        
        // Признак сохранения маршрута
        reactor.state
            .map { $0.isSaved }
            .distinctUntilChanged()
            .skip(1)
            .bind { [weak self] isSaved in
                if isSaved {
                    self?.customView.setStart()
                }
            }
            .disposed(by: disposeBag)
        
        // Выводит ошибку
        reactor.state
            .filter { $0.errorMessage != nil }
            .compactMap { $0.errorMessage }
            .bind { [weak self] message in
                self?.showAlert(title: "Ошибка", message: message)
            }
            .disposed(by: disposeBag)
        
        // Открывает список сохраненных маршрутов
        reactor.state
            .filter { $0.openListRoutes != nil }
            .compactMap { $0.openListRoutes }
            .bind { [weak self] routes in
                self?.delegate?.showListRoutes(with: routes)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func start() {
        userRoute = Route()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = customView.mapView
        
        locationManager.startUpdatingLocation()
    }
    
    private func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        customView.mapView.camera = camera
        customView.mapView.isMyLocationEnabled = true
        customView.mapView.delegate = self
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
