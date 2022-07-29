//
//  SceneDelegate.swift
//  MapExplorer
//
//  Created by Ilya on 15.05.2022.
//

import UIKit
import Swinject
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private var appRouter: AppRouterDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let container = registrationDI()
        appRouter = container.resolve(AppRouterDelegate.self, argument: window)
        appRouter?.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        appRouter?.setBlind(false)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        appRouter?.setBlind(true)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
}

private extension SceneDelegate {
    func registrationDI() -> Container {
        let container = Container()
        // Карта
        container.register(MapViewController.self) { _ in
            let viewModel = MapViewModel()
            let locationManager = LocationManagerImpl()
            let controller = MapViewController(viewModel: viewModel, locationManager: locationManager)
            return controller
        }
        
        // Список сохраненных маршрутов
        container.register(RoutesViewController.self) { (_, routes: [Route]) in
            let viewModel = RoutesViewModel()
            let controller = RoutesViewController(routes: routes, viewModel: viewModel)
            return controller
        }
        
        // Выбранный сохранненый маршрут
        container.register(SelectRouteViewController.self) { (_, locations: [Location]) in
            let controller = SelectRouteViewController(locations: locations)
            return controller
        }
        
        // Авторизация
        container.register(LoginViewController.self) { _ in
            let viewModel = LoginViewModel()
            let controller = LoginViewController(viewModel: viewModel)
            return controller
        }
        
        // Регистрация
        container.register(RegistrationViewController.self) { _ in
            let viewModel = RegistrationViewModel()
            let controller = RegistrationViewController(viewModel: viewModel)
            return controller
        }
        
        // Шторка для приватной информации
        container.register(BlindViewController.self) { _ in BlindViewController() }
        
        // Роутер
        container.register(AppRouterDelegate.self) { (_, window: UIWindow?) in
            let controller = AppRouter(window: window, container: container)
            return controller
        }
        
        return container
    }
}
