//
//  RoutesView.swift
//  MapExplorer
//
//  Created by Ilya on 19.06.2022.
//

import UIKit

class RoutesView: UIView {
    enum Cell {
        static let reuseId = "RoutesView"
    }
    
    /// Список маршрутов
    private(set) var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: RoutesView.Cell.reuseId)
        return tableView
    }()
    
    /// Сообщение об ошибке
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.Routes.emptyRoutes
        return label
    }()
    
    // MARK: - Public methods
    
    func setupView() {
        backgroundColor = .white
        errorLabel.isHidden = true
        
        addSubviews()
        setConstraints()
    }
    
    func setError() {
        tableView.isHidden = true
        errorLabel.isHidden = false
    }

    // MARK: - Private methods
    
    private func addSubviews() {
        addSubviews([tableView, errorLabel])
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        errorLabel.snp.makeConstraints { $0.centerY.centerX.equalToSuperview() }
    }
    
}
