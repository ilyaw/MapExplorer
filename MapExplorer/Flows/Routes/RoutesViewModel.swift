//
//  RoutesViewModel.swift
//  MapExplorer
//
//  Created by Ilya on 19.06.2022.
//

import Foundation
import ReactorKit
import Differentiator


class RoutesViewModel: Reactor {
    struct RouteModel {
        let title: String
    }

    /// Действия
    enum Action {
        case routes([Route])
    }
    
    /// Мутация
    enum Mutation {
        case setRoutesModel([RowOfRouteData])
        case setError(Bool)
    }
    
    /// Состояния
    struct State {
        var rows: [RowOfRouteData] = []
        var isError: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .routes(let data):
            return constuctModel(from: data)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRoutesModel(let newModel):
            newState.rows = newModel
        case .setError(let isError):
            newState.isError = isError
        }
        
        return newState
    }
    
    /// Полученный массив конвертируем в удобную модель для таблицы
    private func constuctModel(from data: [Route]) -> Observable<Mutation> {
        return Single<[RowOfRouteData]>.create { single in
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm:ss a")
            let items = data.map { RouteModel(title: formatter.string(from: $0.date))  }
            let section = RowOfRouteData(items: items)
            single(.success([section]))
            return Disposables.create()
        }
        .asObservable()
        .map({ newModel in
            guard let model = newModel.first, !model.items.isEmpty else { return .setError(true) }
            return .setRoutesModel(newModel)
        })
    }
}
