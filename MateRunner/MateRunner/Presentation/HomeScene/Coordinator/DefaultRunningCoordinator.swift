//
//  DefaultRunningCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import UIKit

final class DefaultRunningCoordinator: RunningCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
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
    
    func pushRunningResultViewController(with runningResult: RunningResult) {
        
    }
    
    private func pushSingleRunningViewController(with settingData: RunningSetting) {
        
    }
    
    private func pushTeamRunningViewController(with settingData: RunningSetting) {
        
    }
    
    private func pushRaceRunningViewController(with settingData: RunningSetting) {
        
    }
    
    
    
}
