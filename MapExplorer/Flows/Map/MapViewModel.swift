//
//  MapViewModel.swift
//  MapExplorer
//
//  Created by Ilya on 18.06.2022.
//

import Foundation
import ReactorKit
import RxSwift
import RealmSwift

class MapViewModel: Reactor {
    private let realmManager = RealmManager.shared
    
    /// Действия
    enum Action {
        case startRoute
        case stopRoute
        case saveRoutes(Route?)
        case openListRoutes
    }
    
    /// Мутация
    enum Mutation {
        case setLoading(Bool)
        case setMotion(Bool)
        case setSave(Bool)
        case setErrorMessage(String?)
        case setOpenListRoutes([Route]?)
    }
    
    /// Состояния
    struct State {
        var isActiveMovement = false
        var isLoading = false
        var isSaved = false
        var errorMessage: String?
        var openListRoutes: [Route]?
    }
    
    let initialState: State = State()
        
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startRoute:
            return .just(.setMotion(true))
        case .stopRoute:
            return .just(.setMotion(false))
        case .openListRoutes:
            return getRoutes()
        case .saveRoutes(let router):
            return Observable<Mutation>.concat([
                .just(.setSave(true)),
                saveRoute(router),
                .just(.setSave(false))
            ])
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setMotion(let isActive):
            newState.isActiveMovement = isActive
        case .setLoading(let status):
            newState.isLoading = status
        case .setSave(let isSave):
            newState.isSaved = isSave
        case .setErrorMessage(let error):
            newState.errorMessage = error
        case .setOpenListRoutes(let routes):
            newState.openListRoutes = routes
        }
        
        return newState
    }
    
    /// Получение сохраненных маршрутов
    private func getRoutes() -> Observable<Mutation> {
        return Single<[Route]>.create { [weak self] single in
            let routes: Results<Route>? = self?.realmManager?.getObjects().sorted(byKeyPath: "date", ascending: false)
            single(.success(routes?.toArray() ?? []))
            return Disposables.create()
        }
        .asObservable()
        .flatMap({ routes -> Observable<Mutation> in
            return .of(.setOpenListRoutes(routes), .setOpenListRoutes(nil))
        })
    }
    
    /// Сохранение маршрута
    private func saveRoute(_ route: Route?) -> Observable<Mutation> {
        return Single<String?>.create { [weak self] single in
            guard let route = route else {
                single(.success("Пустой маршрут"))
                return Disposables.create()
            }
            
            route.date = .now
            do {
                let models: Results<Route>? = self?.realmManager?.getObjects()
                let maxId = models?.value(forKeyPath: "@max.id") as? Int ?? 0
                route.id = maxId + 1
                
                try self?.realmManager?.add(object: route)
                single(.success(nil))
            } catch {
                single(.success("Не удалось сохранить в базу"))
            }
            
            return Disposables.create()
        }
        .asObservable()
        .flatMap({ response -> Observable<Mutation> in
            return .of(.setErrorMessage(response), .setErrorMessage(nil))
        })
    }
}
