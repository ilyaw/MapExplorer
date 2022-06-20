//
//  RowOfRouteData.swift
//  MapExplorer
//
//  Created by Ilya on 20.06.2022.
//

import Foundation
import Differentiator

// Для таблицы
struct RowOfRouteData {
    var items: [Item]
}

extension RowOfRouteData: SectionModelType {
    typealias Item = RoutesViewModel.RouteModel
    
    init(original: RowOfRouteData, items: [Item]) {
        self = original
        self.items = items
    }
}
