//
//  DefaultRunningCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import UIKit

final class DefaultRunningCoordinator: RunningCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .running }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {}
    
    func pushRunningViewController(with settingData: RunningSetting?) {
        guard let settingData = settingData,
              let runningMode = settingData.mode else { return }
        switch runningMode {
        case .single: pushSingleRunningViewController(with: settingData)
        case .race: pushRaceRunningViewController(with: settingData)
        case .team: pushTeamRunningViewController(with: settingData)
        }
    }
    
    func pushRunningResultViewController(with runningResult: RunningResult?) {
        guard let runningResult = runningResult,
              let mode = runningResult.mode else { return }
        
        switch mode {
        case .single:
            self.pushRunningResultViewController(with: runningResult)
        case .race:
            self.pushRaceRunningResultViewController(with: runningResult)
        case .team:
            self.pushTeamRunningResultViewController(with: runningResult)
        }
    }
    
    func pushSingleRunningResultViewController(with runningResult: RunningResult?) {
        guard let runningResult = runningResult else { return }
        let singleRunningResultViewController = SingleRunningResultViewController()
        singleRunningResultViewController.viewModel = SingleRunningResultViewModel(
            coordinator: self,
            runningResultUseCase: DefaultRunningResultUseCase(
                runningResultRepository: DefaultRunningResultRepository(
                    fireStoreService: DefaultFireStoreNetworkService()
                ),
                runningResult: runningResult
            )
        )
        self.navigationController.pushViewController(singleRunningResultViewController, animated: true)
    }
    
    func pushRaceRunningResultViewController(with runningResult: RunningResult?) {
        guard let runningResult = runningResult,
              runningResult.isCanceled == false else {
                  self.pushCancelRunningResultViewController(with: runningResult)
                  return
              }
        
        let raceRunningResultViewController = RaceRunningResultViewController()
        raceRunningResultViewController.viewModel = RaceRunningResultViewModel(
            coordinator: self,
            runningResultUseCase: DefaultRunningResultUseCase(
                runningResultRepository: DefaultRunningResultRepository(
                    fireStoreService: DefaultFireStoreNetworkService()
                ),
                runningResult: runningResult
            )
        )
        self.navigationController.pushViewController(raceRunningResultViewController, animated: true)
    }
    
    func pushTeamRunningResultViewController(with runningResult: RunningResult?) {
        guard let runningResult = runningResult else { return }
        let teamRunningResultViewController = TeamRunningResultViewController()
        self.navigationController.pushViewController(teamRunningResultViewController, animated: true)
    }
    
    func pushCancelRunningResultViewController(with runningResult: RunningResult?) {
        guard let runningResult = runningResult else { return }
        let cancelRunningResultViewController = CancelRunningResultViewController()
        self.navigationController.pushViewController(cancelRunningResultViewController, animated: true)
    }
    
    private func pushSingleRunningViewController(with settingData: RunningSetting) {
        let singleRunningViewController = SingleRunningViewController()
        let runningUseCase = self.createRunningUseCase(with: settingData)
        
        singleRunningViewController.viewModel = SingleRunningViewModel(
            coordinator: self,
            runningUseCase: runningUseCase
        )
        
        self.configureMapViewController(delegate: runningUseCase, to: singleRunningViewController)
        self.navigationController.pushViewController(singleRunningViewController, animated: true)
    }
    
    private func pushTeamRunningViewController(with settingData: RunningSetting) {
        let teamRunningViewController = TeamRunningViewController()
        let runningUseCase = self.createRunningUseCase(with: settingData)
        
        teamRunningViewController.viewModel = TeamRunningViewModel(
            coordinator: self,
            runningUseCase: runningUseCase
        )
        
        self.configureMapViewController(delegate: runningUseCase, to: teamRunningViewController)
        self.navigationController.pushViewController(teamRunningViewController, animated: true)
    }
    
    private func pushRaceRunningViewController(with settingData: RunningSetting) {
        let raceRunningViewController = RaceRunningViewController()
        let runningUseCase = self.createRunningUseCase(with: settingData)
        
        raceRunningViewController.viewModel = RaceRunningViewModel(
            coordinator: self,
            runningUseCase: runningUseCase
        )
        
        self.configureMapViewController(delegate: runningUseCase, to: raceRunningViewController)
        self.navigationController.pushViewController(raceRunningViewController, animated: true)
    }
    
    private func createRunningUseCase(with settingData: RunningSetting) -> DefaultRunningUseCase {
        return DefaultRunningUseCase(
            runningSetting: settingData,
            cancelTimer: DefaultRxTimerService(),
            runningTimer: DefaultRxTimerService(),
            popUpTimer: DefaultRxTimerService(),
            coreMotionService: DefaultCoreMotionService(),
            runningRepository: DefaultRunningRepository(),
            userRepository: DefaultUserRepository(userDefaultPersistence: DefaultUserDefaultPersistence())
        )
    }
    
    private func configureMapViewController(
        delegate useCase: DefaultRunningUseCase,
        to runningViewController: RunningViewController
    ) {
        let mapViewModel = MapViewModel(
            mapUseCase: DefaultMapUseCase(
                locationService: DefaultLocationService(),
                delegate: useCase
            )
        )
        runningViewController.mapViewController = MapViewController()
        runningViewController.mapViewController?.viewModel = mapViewModel
    }
}
