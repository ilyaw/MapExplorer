//
//  RegistrationViewModel.swift
//  MapExplorer
//
//  Created by Ilya on 25.06.2022.
//

import Foundation
import ReactorKit
import RealmSwift

class RegistrationViewModel: Reactor {
    private let realmManager = RealmManager.shared
    
    /// Действия
    enum Action {
        case signup(String, String)
    }
    
    /// Мутация
    enum Mutation {
        case setSuccessfully(Bool)
    }
    
    /// Состояния
    struct State {
        var isSuccessfully: Bool = false
    }
    
    let initialState: State = State()
        
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .signup(username, password):
            return signup(username: username, password: password)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSuccessfully(let status):
            newState.isSuccessfully = status
        }
        
        return newState
    }
    
    var qwe = false
    
    /// Регистрация
    private func signup(username: String, password: String) -> Observable<Mutation> {
        return Single<Bool>.create { [weak self] single in
            guard !username.isEmpty || !password.isEmpty else {
                single(.success(false))
                return Disposables.create()
            }
            
            let user: Results<User>? = self?.realmManager?.getObjects().filter("username == %@ AND password == %@",
                                                                                 username, password)
            
            do {
                let userModel = User(username: username, password: password)
                if user == nil {
                    try self?.realmManager?.add(object: userModel)
                } else {
                    try self?.realmManager?.addWithModified(object: userModel)
                }
            } catch {
                single(.success(false))
                return Disposables.create()
            }
    
            UserDefaults.standard.set(true, forKey: AppConstants.loginKey)
            single(.success(true))
            return Disposables.create()
        }
        .asObservable()
        .map ({ status in
            return .setSuccessfully(status)
        })
    }
}
