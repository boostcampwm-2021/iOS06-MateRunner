//
//  DefaultHomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

final class DefaultHomeCoordinator: HomeCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .home }
    
    func start() {
        let homeViewController = createHomeViewController()
        self.navigationController.pushViewController(homeViewController, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func createHomeViewController() -> UIViewController {
        let homeViewController = HomeViewController()
        homeViewController.viewModel = HomeViewModel(
            coordinator: self,
            homeUseCase: HomeUseCase()
        )
        return homeViewController
    }
    
    func pushRunningModeSettingViewController() {
        let runningModeSettingViewController = RunningModeSettingViewController()
        runningModeSettingViewController.viewModel = RunningModeSettingViewModel(
            coordinator: self,
            runningSettingUseCase: DefaultRunningSettingUseCase(
                runningSetting: RunningSetting()
            )
        )
        self.navigationController.pushViewController(runningModeSettingViewController, animated: true)
    }
    
    func pushMateRunningModeSettingViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData else { return }
        let mateRunningModeSettingViewController = MateRunningModeSettingViewController()
        self.navigationController.pushViewController(mateRunningModeSettingViewController, animated: true)
    }
    
    func pushDistanceSettingViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData else { return }
        let distanceSettingViewController = DistanceSettingViewController()
        distanceSettingViewController.viewModel = DistanceSettingViewModel(
            coordinator: self,
            distanceSettingUseCase: DefaultDistanceSettingUseCase(),
            runningSettngUseCase: DefaultRunningSettingUseCase(runningSetting: settingData)
        )
        self.navigationController.pushViewController(distanceSettingViewController, animated: true)
    }
    
    func pushRunningPreparationViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData else { return }
        let runningPreparationViewController = RunningPreparationViewController()
        self.navigationController.pushViewController(runningPreparationViewController, animated: true)
    }
}
