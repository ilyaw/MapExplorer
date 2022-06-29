//
//  SceneDelegate.swift
//  MapExplorer
//
//  Created by Ilya on 15.05.2022.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var appRouter: AppRouterDelegate?
    private let container: Container = {
        let container = Container()
        // Карта
        container.register(MapViewController.self) { _ in
            let viewModel = MapViewModel()
            let controller = MapViewController(viewModel: viewModel)
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
        
        // Роутер
        container.register(AppRouterDelegate.self) { (_, window: UIWindow?) in
            let controller = AppRouter(window: window, container: container)
            return controller
        }
        return container
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        appRouter = container.resolve(AppRouterDelegate.self, argument: window)
        appRouter?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
