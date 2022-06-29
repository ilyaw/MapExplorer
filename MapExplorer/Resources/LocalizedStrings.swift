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
    
    struct Login {
        /// Авторизация
        static let title = "login_title".localized
        /// Ваш логин
        static let inputLogin = "login_input_login".localized
        /// Ваш пароль
        static let inputPassword = "login_input_password".localized
        /// Авторизоваться
        static let authorizeButtonTitle = "login_authorize_button".localized
        /// Создать аккаунт
        static let createAccountButtonTitle = "login_create_account_button".localized
        /// Неверный логин или пароль
        static let userInvalid = "login_user_invalid".localized
    }

    struct Registration {
        /// Регистрация
        static let title = "registration_title".localized
        /// Зарегистрироваться
        static let buttonTitle = "registration_button_title".localized
        /// Ошибка регистрации
        static let registrationError = "registration_error".localized
    }
}
