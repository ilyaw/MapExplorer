//
//  MapView.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import UIKit
import SnapKit
import GoogleMaps

class MapView: UIView {
    /// Карта
    private(set) var mapView: GMSMapView = {
        let map = GMSMapView()
        return map
    }()
    
    func setupView() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(mapView)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
}
