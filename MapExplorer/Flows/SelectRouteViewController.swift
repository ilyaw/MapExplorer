//
//  SelectRouteViewController.swift
//  MapExplorer
//
//  Created by Ilya on 20.06.2022.
//

import UIKit
import RxSwift
import GoogleMaps

/// Экран с выбранным маршрутом
class SelectRouteViewController: UIViewController {

    // MARK: - Private properties
    
    private let customView = SelectRouteView(frame: UIScreen.main.bounds)
    private let locations: [Location]
    private var disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    init(locations: [Location]) {
        self.locations = locations
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
        
        bind()
        setupMap()
    }
    
    // MARK: - Private methods
    
    private func bind() {
        customView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupMap() {
        guard let firstLocation = locations.first?.coordinate,
              let lastLocation = locations.last?.coordinate else { return }

        let path = GMSMutablePath()
        
        _ = locations.map { path.add($0.coordinate) }
        
        let startMarker = GMSMarker(position: firstLocation)
        startMarker.map = customView.mapView
        startMarker.title = Strings.SelectRoute.start
        
        let finishMarker = GMSMarker(position: lastLocation)
        finishMarker.map = customView.mapView
        finishMarker.title = Strings.SelectRoute.finish
       
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 12
        polyline.strokeColor = .blue
        polyline.map = customView.mapView
        
        let position = GMSCameraPosition.camera(withTarget: firstLocation, zoom: 15)
        customView.mapView.animate(to: position)
    }

}
