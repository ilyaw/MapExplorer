//
//  LoginViewModel.swift
//  MapExplorer
//
//  Created by Ilya on 21.06.2022.
//

import Foundation
import ReactorKit
import RealmSwift

class LoginViewModel: Reactor {
    private let realmManager = RealmManager.shared
    
    /// Действия
    enum Action {
        case login(String, String)
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
        case let .login(username, password):
            return login(username: username, password: password)
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
    
    /// Авторизация
    private func login(username: String, password: String) -> Observable<Mutation> {
        return Single<Bool>.create { [weak self] single in
            guard !username.isEmpty || !password.isEmpty else {
                single(.success(false))
                return Disposables.create()
            }
            
            guard let user: Results<User> = self?.realmManager?.getObjects().filter("username == %@ AND password == %@",
                                                                                     username, password), !user.isEmpty else {
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
