//
//  AppCoordinator.swift
//  MapExplorer
//
//  Created by Ilya on 19.06.2022.
//

import Foundation
import Swinject

/// Делегат для роутера
protocol AppRouterDelegate: AnyObject {
    /// Навигационный контроллер
    var navigationController: UINavigationController { get }
    /// Открывает экран со списком сохраненных маршутов
    func openListRoutes(_ routes: [Route])
    /// Открывает экран с картой
    func openMap()
    /// Презентует экран с выбранным маршрутом
    func showRoute(locations: [Location])
    /// Показываем/скрываем шторку
    func setBlind(_ isActive: Bool)
    /// Запуск координатора
    func start()
}

/// Роутер для навигации
class AppRouter: AppRouterDelegate {
    
    private(set) var navigationController = UINavigationController()
    
    private let window: UIWindow?
    private let container: Container
    
    init(window: UIWindow?, container: Container) {
        self.window = window
        self.container = container
    }
    
    // MARK: - Public methods
    
    func start() {
        UserDefaults.standard.set(false, forKey: AppConstants.loginKey)
        if UserDefaults.standard.bool(forKey: AppConstants.loginKey) {
            openMap()
        } else {
            openLoginPage()
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func openLoginPage() {
        guard let controller = container.resolve(LoginViewController.self) else { return }
        controller.delegate = self
        setViewController(controller)
    }
    
    func openRegistrationPage() {
        guard let controller = container.resolve(RegistrationViewController.self) else { return }
        controller.delegate = self
        pushViewController(controller)
    }
    
    func openListRoutes(_ routes: [Route]) {
        guard let controller = container.resolve(RoutesViewController.self, argument: routes) else { return }
        controller.delegate = self
        pushViewController(controller)
    }
    
    func openMap() {
        guard let controller = container.resolve(MapViewController.self) else { return }
        controller.delegate = self
        setViewController(controller)
    }
    
    func showRoute(locations: [Location]) {
        guard let controller = container.resolve(SelectRouteViewController.self, argument: locations) else { return }
        present(controller)
    }

    func setBlind(_ isActive: Bool) {
        guard let controller = container.resolve(BlindViewController.self) else { return }
        controller.modalPresentationStyle = .fullScreen
        if isActive {
            present(controller, animated: false)
        } else {
            dismiss(animated: false)
        }
    }
    
    // MARK: - Private methods
    
    private func pushViewController(_ controller: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(controller, animated: animated)
    }
    
    private func present(_ controller: UIViewController, animated: Bool = true) {
        navigationController.present(controller, animated: animated)
    }
    
    private func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: false)
    }
    
    private func setViewControllers(_ controllers: [UIViewController], animated: Bool = true) {
        navigationController.setViewControllers(controllers, animated: true)
    }
    
    private func setViewController(_ controllers: UIViewController, animated: Bool = true) {
        navigationController.setViewControllers([controllers], animated: true)
    }
}

// MARK: - MapDelegate
extension AppRouter: MapDelegate {
    func showListRoutes(with routes: [Route]) {
        openListRoutes(routes)
    }
}

// MARK: - RoutesDelegate
extension AppRouter: RoutesDelegate {
    func showSelectedRoute(locations: [Location]) {
        showRoute(locations: locations)
    }
}

// MARK: - LoginDelegate
extension AppRouter: LoginDelegate {
    func createAccount() {
        openRegistrationPage()
    }
}

// MARK: - RegistrationDelegate
extension AppRouter: RegistrationDelegate {
    func goToMainScreen() {
        openMap()
    }
}
