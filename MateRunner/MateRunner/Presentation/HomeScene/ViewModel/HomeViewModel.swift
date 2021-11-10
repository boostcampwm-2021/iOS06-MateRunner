//
//  HomeViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import Foundation

final class HomeViewModel {
    weak var coordinator: SettingCoordinator?
    let homeUseCase: HomeUseCase
    
    init(coordinator: SettingCoordinator, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    func startButtonDidTap() {
        self.coordinator?.pushRunningModeSettingViewController()
    }
}
