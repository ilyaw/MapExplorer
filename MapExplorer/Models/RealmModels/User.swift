//
//  User.swift
//  MapExplorer
//
//  Created by Ilya on 25.06.2022.
//

import Foundation
import RealmSwift

/// Модель пользователя
class User: Object {
    @Persisted(primaryKey: true) var username: String
    @Persisted var password: String
    
    convenience init(username: String, password: String) {
        self.init()
        self.username = username
        self.password = password
    }
}
