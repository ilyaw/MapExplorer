//
//  Route.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import Foundation
import RealmSwift

/// Путь
class Route: Object {
    @Persisted(primaryKey: true) var id = 0
    /// Дата поездки
    @Persisted var date = Date()
    /// Координаты
    @Persisted var locations = List<Location>()
}
