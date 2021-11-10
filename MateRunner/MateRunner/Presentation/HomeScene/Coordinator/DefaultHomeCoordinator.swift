//
//  DefaultHomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import UIKit

class DefaultHomeCoorditnator: HomeCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var homeViewController: HomeViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .home
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
    }
    
    func start() {
        self.navigationController.pushViewController(homeViewController, animated: true)
        self.showSettingFlow()
    }
  
    func showSettingFlow() {
        let settingCoordinator = DefaultSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        homeViewController.viewModel = HomeViewModel(
            coordinator: settingCoordinator,
            homeUseCase: HomeUseCase()
        )
        settingCoordinator.start()
        childCoordinators.append(settingCoordinator)
    }
    
    func showRunningFlow() {
        // 운동중 화면 플로우
    }
}

extension DefaultHomeCoorditnator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        navigationController.popToRootViewController(animated: false)
        print("move to running!!")
    }
}
