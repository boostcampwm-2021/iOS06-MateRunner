//
//  DefaultHomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

final class DefaultSettingCoordinator: SettingCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .setting }
    
    func start() {
        print("coordinator is ready")
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        runningPreparationViewController.viewModel = RunningPreparationViewModel(
            coordinator: self,
            runningPreparationUseCase: DefaultRunningPreparationUseCase(
                runningSetting: settingData
            )
        )
        self.navigationController.pushViewController(runningPreparationViewController, animated: true)
    }
    
    func finish(with settingData: RunningSetting) {
        var settingData = settingData
        settingData.dateTime = Date()
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        self.settingFinishDelegate?.settingCoordinatorDidFinish(with: settingData)
    }
}
