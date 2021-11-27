//
//  DefaultLicenseCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import UIKit

final class DefaultLicenseCoordinator: LicenseCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .license
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.pushLicenseViewController()
    }
    
    func pushLicenseViewController() {
        let licenseViewController = LicenseViewController()
        licenseViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(licenseViewController, animated: true)
    }
}
