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
        loginViewController.viewModel = LoginViewModel(coordinator: self)
        self.navigationController.viewControllers = [loginViewController]
    }
    
    func showSignUpFlow() {
        let signUpCoordinator = DefaultSignUpCoordinator(self.navigationController)
        self.childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }
}
