//
//  HomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    func start() {
    }
    
    func pushToHome() -> UINavigationController {
        let homeViewController = HomeViewController()
        homeViewController.delegate = self
        homeViewController.view.backgroundColor = .white
        navigationController.setViewControllers([homeViewController], animated: true)
        
        return navigationController
    }
}
