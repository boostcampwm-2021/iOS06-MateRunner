//
//  HomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

class HomeCoordinator: Coordinating {
    weak var parentCoordinator: Coordinating?
    var childCoordinators: [Coordinating] = []
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
