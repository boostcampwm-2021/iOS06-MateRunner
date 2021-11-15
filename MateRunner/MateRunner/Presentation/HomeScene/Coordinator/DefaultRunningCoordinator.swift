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
        let runningResultViewController = RunningResultViewController()
        self.navigationController.pushViewController(runningResultViewController, animated: true)
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
        singleRunningViewController.viewModel = SingleRunningViewModel(
            coordinator: self,
            runningUseCase: DefaultRunningUseCase(runningSetting: settingData)
        )
        singleRunningViewController.mapViewController = MapViewController()
        singleRunningViewController.mapViewController?.viewModel = self.makeMapViewModel()
        self.navigationController.pushViewController(singleRunningViewController, animated: true)
    }
    
    private func pushTeamRunningViewController(with settingData: RunningSetting) {
        let teamRunningViewController = TeamRunningViewController()
        self.navigationController.pushViewController(teamRunningViewController, animated: true)
        // TODO: 뷰모델 생성 및 유즈케이스에 setting 값 주입 작성
    }
    
    private func pushRaceRunningViewController(with settingData: RunningSetting) {
        let raceRunningViewController = RaceRunningViewController()
        self.navigationController.pushViewController(raceRunningViewController, animated: true)
        // TODO: 뷰모델 생성 및 유즈케이스에 setting 값 주입 작성
    }
    
    private func makeMapViewModel() -> MapViewModel {
        func makeLocationRepository() -> LocationRepository {
            return DefaultLocationRepository(locationService: DefaultLocationService())
        }
        func makeMapUseCase() -> MapUseCase {
            return  DefaultMapUseCase(repository: makeLocationRepository())
        }
        return MapViewModel(mapUseCase: makeMapUseCase())
    }
}
