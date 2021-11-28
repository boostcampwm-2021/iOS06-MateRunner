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
        self.loginViewController.viewModel = LoginViewModel(
            coordinator: self,
            loginUseCase: DefaultLoginUseCase(
                repository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService(),
                    realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                )
            )
        )
        self.navigationController.viewControllers = [self.loginViewController]
    }
    
    func showSignUpFlow(with uid: String) {
        let signUpCoordinator = DefaultSignUpCoordinator(self.navigationController)
        signUpCoordinator.finishDelegate = self
        self.childCoordinators.append(signUpCoordinator)
        signUpCoordinator.pushSignUpViewController(with: uid)
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultLoginCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
