//
//  DefaultLoginCoordinator.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import UIKit

final class DefaultLoginCoordinator: LoginCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var loginViewController: LoginViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .login
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.loginViewController = LoginViewController()
    }
    
    func start() {
        self.navigationController.viewControllers = [loginViewController]
    }
}
