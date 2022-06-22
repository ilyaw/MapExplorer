//
//  AppCoordinator.swift
//  MapExplorer
//
//  Created by Ilya on 19.06.2022.
//

import Foundation
import Swinject

/// Делегат для координатора
protocol AppCoordinatorDelegate: AnyObject {
    /// Открывает экран со списком сохраненных маршутов
    func openListRoutes(_ routes: [Route])
    /// Открывает экран с картой
    func openMap()
    /// Презентует экран с выбранным маршрутом
    func showRoute(locations: [Location])
    /// Запуск координатора
    func start()
}

/// Недокоординатор
class AppCoordinator: AppCoordinatorDelegate {
    
    private let window: UIWindow?
    private let container: Container
    private let navigationController = UINavigationController()
    
    init(window: UIWindow?, container: Container) {
        self.window = window
        self.container = container
    }
    
    func start() {
        openMap()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func openListRoutes(_ routes: [Route]) {
        guard let controller = container.resolve(RoutesViewController.self, argument: routes) else { return }
        controller.delegate = self
        
        pushViewController(controller)
    }
    
    func openMap() {
        guard let controller = container.resolve(MapViewController.self) else { return }
        controller.delegate = self
        
        navigationController.setViewControllers([controller], animated: true)
    }
    
    func showRoute(locations: [Location]) {
        guard let controller = container.resolve(SelectRouteViewController.self, argument: locations) else { return }
        
        present(controller)
    }
    
    private func pushViewController(_ controller: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(controller, animated: animated)
    }
    
    private func present(_ controller: UIViewController, animated: Bool = true) {
        navigationController.present(controller, animated: animated)
    }
    
}

// MARK: - MapDelegate
extension AppCoordinator: MapDelegate {
    func showListRoutes(with routes: [Route]) {
        openListRoutes(routes)
    }
}

// MARK: - RoutesDelegate
extension AppCoordinator: RoutesDelegate {
    func showSelectedRoute(locations: [Location]) {
        showRoute(locations: locations)
    }
}
