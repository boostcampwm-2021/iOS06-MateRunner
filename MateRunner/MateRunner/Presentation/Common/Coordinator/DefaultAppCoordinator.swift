//
//  AppCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//
//
import UIKit

final class DefaultAppCoordinator: AppCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.isLoggedIn) {
            self.showTabBarFlow()
        } else {
            self.showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = DefaultTabBarCoordinator(self.navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        
        self.navigationController.view.backgroundColor = .systemBackground
        self.navigationController.viewControllers.removeAll()
        
        if childCoordinator.type == .login {
            self.showTabBarFlow()
        } else if childCoordinator.type == .tab {
            self.showLoginFlow()
        }
    }
}
