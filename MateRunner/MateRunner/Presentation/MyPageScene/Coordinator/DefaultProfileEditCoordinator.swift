//
//  DefaultProfileEditCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import UIKit

final class DefaultProfileEditCoordinator: ProfileEditCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .profileEdit
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.pushProfileEditViewController()
    }
    
    func pushProfileEditViewController() {
        let profileEditViewController = ProfileEditViewController()
        profileEditViewController.viewModel = ProfileEditViewModel(
            profileEditCoordinator: self,
            profileEditUseCase: DefaultProfileEditUseCase()
        )
        self.navigationController.pushViewController(profileEditViewController, animated: true)
    }
}
