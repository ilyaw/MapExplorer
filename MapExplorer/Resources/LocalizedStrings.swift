//
//  LocalizedStrings.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import Foundation

/// Для локализации
struct Strings {
    struct Map {
        /// Начать
        static let start = "map_start".localized
        /// Остановить
        static let stop = "map_stop".localized
        /// Маршруты
        static let routers = "map_routers".localized
    }
    
    struct Routes {
        /// Маршруты
        static let title = "routes_title".localized
        /// Список маршутов пуст
        static let emptyRoutes = "routes_emptyRoutes".localized
    }
    
    struct SelectRoute {
        /// Закрыть
        static let close = "selectRoute_close".localized
        /// Старт
        static let start = "selectRoute_start".localized
        /// Финиш
        static let finish = "selectRoute_finish".localized
    }
    
}
