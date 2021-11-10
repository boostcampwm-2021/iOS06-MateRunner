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
        self.homeViewController.viewModel = HomeViewModel(
            coordinator: self,
            homeUseCase: HomeUseCase()
        )
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
  
    func showSettingFlow() {
        let settingCoordinator = DefaultSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
    func showRunningFlow() {
        // 운동중 화면 플로우
    }
}

extension DefaultHomeCoorditnator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        navigationController.popToRootViewController(animated: false)
    }
}

extension DefaultHomeCoorditnator: SettingCoordinatorDidFinishDelegate {
    func settingCoordinatorDidFinish(with runningSettingData: RunningSetting) {
        print(runningSettingData)
    }
}
