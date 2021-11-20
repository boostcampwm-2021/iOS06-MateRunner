//
//  DefaultMateProfileCoordinator.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import UIKit

final class DefaultMateProfileCoordinator: MateProfileCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .addMate }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.pushMateProfileViewController()
    }
    
    func pushMateProfileViewController() {
        let mateProfileViewController = MateProfileViewController()
        self.navigationController.pushViewController(mateProfileViewController, animated: true)
    }
}
