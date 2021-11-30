//
//  DefaultStartCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/30.
//

import UIKit

final class DefaultStartCoordinator: StartCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .start

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let startViewModel = StartViewModel(startCoordinator: self)
        let startViewController = StartViewController()
        startViewController.viewModel = startViewModel
        self.navigationController.viewControllers = [startViewController]
    }
    
    func pushTermsViewController() {
        let termsViewModel = TermsViewModel(startCoordinator: self)
        let termsViewController = TermsViewController()
        termsViewController.viewModel = termsViewModel
        self.navigationController.pushViewController(termsViewController, animated: true)
    }
}
