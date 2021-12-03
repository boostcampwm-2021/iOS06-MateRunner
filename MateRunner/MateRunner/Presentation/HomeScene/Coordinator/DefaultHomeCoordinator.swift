//
//  DefaultHomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import UIKit

final class DefaultHomeCoordinator: HomeCoordinator {
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
            homeUseCase: DefaultHomeUseCase(locationService: DefaultLocationService())
        )
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func start(with settingData: RunningSetting) {
        let settingCoordinator = DefaultRunningSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        self.childCoordinators.append(settingCoordinator)
    }
    
    func showSettingFlow() {
        let settingCoordinator = DefaultRunningSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
    func showRunningFlow(with initialSettingData: RunningSetting) {
        let runningCoordinator = DefaultRunningCoordinator(self.navigationController)
        runningCoordinator.finishDelegate = self
        self.childCoordinators.append(runningCoordinator)
        runningCoordinator.pushRunningViewController(with: initialSettingData)
    }
    
    func startRunningFromInvitation(with settingData: RunningSetting) {
        let settingCoordinator = DefaultRunningSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.pushRunningPreparationViewController(with: settingData)
    }
}

extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

extension DefaultHomeCoordinator: SettingCoordinatorDidFinishDelegate {
    func settingCoordinatorDidFinish(with runningSettingData: RunningSetting) {
        self.showRunningFlow(with: runningSettingData)
    }
}
