//
//  DefaultHomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

final class DefaultRunningSettingCoordinator: RunningSettingCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .setting }
    
    func start() {
        self.pushRunningModeSettingViewController()
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
        mateRunningModeSettingViewController.viewModel = MateRunningModeSettingViewModel(
            coordinator: self,
            runningSettingUseCase: DefaultRunningSettingUseCase(runningSetting: settingData)
        )
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
    
    func navigateProperViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData else { return }
        switch settingData.mode {
        case .single:
            self.pushRunningPreparationViewController(with: settingData)
        case .race, .team:
            self.pushInvitationWaitingViewController(with: settingData)
        case .none:
            break
        }
    }
    
    func pushInvitationWaitingViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData else { return }
        let invitationWaitingViewController = InvitationWaitingViewController()
        invitationWaitingViewController.viewModel = InvitationWaitingViewModel(
            coordinator: self,
            invitationWaitingUseCase: DefaultInvitationWaitingUseCase(
                runningSetting: settingData
            )
        )
        self.navigationController.pushViewController(invitationWaitingViewController, animated: true)
    }
    
    func pushRunningPreparationViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData else { return }
        let runningPreparationViewController = RunningPreparationViewController()
        runningPreparationViewController.viewModel = RunningPreparationViewModel(
            coordinator: self,
            runningSettingUseCase: DefaultRunningSettingUseCase(runningSetting: settingData),
            runningPreparationUseCase: DefaultRunningPreparationUseCase()
        )
        self.navigationController.pushViewController(runningPreparationViewController, animated: true)
    }
    
    func pushMateSettingViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData else { return }
        let inviteMateViewController = MateSettingViewController()
        inviteMateViewController.mateViewModel = MateViewModel( // 부모
            coordinator: self,
            mateUseCase: DefaultMateUseCase(
                repository: DefaultMateRepository(
                    networkService: FireStoreNetworkService()
                )
            )
        )
        inviteMateViewController.viewModel = MateSettingViewModel( // 자식 자기자신
            coordinator: self,
            runningSettingUseCase: DefaultRunningSettingUseCase(runningSetting: settingData)
        )
        self.navigationController.pushViewController(inviteMateViewController, animated: true)
    }
    
    func finish(with settingData: RunningSetting) {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        self.settingFinishDelegate?.settingCoordinatorDidFinish(with: settingData)
    }
}
