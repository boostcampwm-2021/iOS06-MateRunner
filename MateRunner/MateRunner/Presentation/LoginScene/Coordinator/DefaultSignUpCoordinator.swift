//
//  DefaultSignUpCoordinator.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import UIKit

final class DefaultSignUpCoordinator: SignUpCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var signUpViewController: SignUpViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .login
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signUpViewController = SignUpViewController()
    }
    
    func start() {
        self.navigationController.pushViewController(self.signUpViewController, animated: true)
    }
}
