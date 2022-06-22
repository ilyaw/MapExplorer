//
//  MapView.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import UIKit
import SnapKit
import GoogleMaps

extension MapView {
    private struct Appearance {
        let bottomPanelTopInset: CGFloat = 20
        let bottomPanelHeight: CGFloat = 50
        let bottomPanelLeftRightInset: CGFloat = 10
    }
}

class MapView: UIView {
    
    /// Стили
    private let appearance = Appearance()
    /// Карта
    private(set) var mapView = GMSMapView()
    /// Кнопка запустить
    private(set) var startButton = Button(title: Strings.Map.start)
    /// Кнопка остановить
    private(set) var stopButton = Button(title: Strings.Map.stop)
    /// Кнопка для открытия списка маршрутов
    private(set) var openRoutesButton = Button(title: Strings.Map.routers)

    /// Нижняя панель действий
    private let bottomPanelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Public methods
    
    func setupView() {
        backgroundColor = .white
        
        stopButton.isHidden = true
        addSubviews()
        setConstraints()
    }
    
    func setStart() {
        startButton.isHidden = false
        stopButton.isHidden = true
        stopButton.isEnabled = false
    }
    
    func setStop() {
        startButton.isHidden = true
        stopButton.isHidden = false
        stopButton.isEnabled = true
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        bottomPanelStackView.addArrangedSubviews([startButton, stopButton, openRoutesButton])
        addSubviews([mapView, bottomPanelStackView])
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        bottomPanelStackView.snp.makeConstraints { make in
            make.left.right.equalTo(safeAreaLayoutGuide).inset(appearance.bottomPanelLeftRightInset)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(appearance.bottomPanelHeight)
        }
    }
}
