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
        guard let runningResult = runningResult else { return }
        let singleRunningResultViewController = RunningResultViewController()
        singleRunningResultViewController.viewModel = RunningResultViewModel(
            coordinator: self,
            runningResultUseCase: DefaultRunningResultUseCase(
                runningResultRepository: DefaultRunningResultRepository(),
                runningResult: runningResult
            )
        )
        self.navigationController.pushViewController(singleRunningResultViewController, animated: true)
    }
    
    func pushRaceRunningResultViewController(with runningResult: RunningResult?) {
        guard let runningResult = runningResult else { return }
        let raceRunningResultViewController = RaceRunningResultViewController()
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
        self.navigationController.pushViewController(teamRunningViewController, animated: true)
        
        // TODO: 뷰모델 생성 및 유즈케이스에 setting 값 주입 작성
        //        teamRunningViewController.viewModel = TeamRunningViewController(
        //            coordinator: self,
        //            runningUseCase: runningUseCase
        //        )
        
        self.configureMapViewController(delegate: runningUseCase, to: teamRunningViewController)
        self.navigationController.pushViewController(teamRunningViewController, animated: true)
    }
    
    private func pushRaceRunningViewController(with settingData: RunningSetting) {
        let raceRunningViewController = RaceRunningViewController()
        let runningUseCase = self.createRunningUseCase(with: settingData)
        
        // TODO: 뷰모델 생성 및 유즈케이스에 setting 값 주입 작성
        //        teamRunningViewController.viewModel = TeamRunningViewController(
        //            coordinator: self,
        //            runningUseCase: runningUseCase
        //        )
        
        self.configureMapViewController(delegate: runningUseCase, to: raceRunningViewController)
        self.navigationController.pushViewController(raceRunningViewController, animated: true)
    }
    
    private func createRunningUseCase(with settingData: RunningSetting) -> DefaultRunningUseCase {
        return DefaultRunningUseCase(
            runningSetting: settingData,
            cancelTimer: DefaultRxTimerService(),
            runningTimer: DefaultRxTimerService(),
            popUpTimer: DefaultRxTimerService(),
            coreMotionService: DefaultCoreMotionService()
        )
    }
    
    private func configureMapViewController(
        delegate useCase: DefaultRunningUseCase,
        to runningViewController: SingleRunningViewController
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
