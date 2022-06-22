//
//  SelectRouteView.swift
//  MapExplorer
//
//  Created by Ilya on 20.06.2022.
//

import UIKit
import GoogleMaps

extension SelectRouteView {
    private struct Appearance {
        let closeButtonHeight: CGFloat = 50
        let leftRightCloseButtonInset: CGFloat = 20
    }
}

class SelectRouteView: UIView {
    
    /// Стили
    private let appearance = Appearance()
    /// Карта
    private(set) var mapView = GMSMapView()
    /// Кнопка запустить
    private(set) var closeButton = Button(title: Strings.SelectRoute.close)
    
    // MARK: - Public methods
    
    func setupView() {
        backgroundColor = .white
        
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        addSubviews([mapView, closeButton])
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(appearance.closeButtonHeight)
            make.left.right.equalToSuperview().inset(appearance.leftRightCloseButtonInset)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
