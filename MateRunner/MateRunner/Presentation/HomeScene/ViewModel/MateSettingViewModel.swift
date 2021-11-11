//
//  MateSettingViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/11.
//

import Foundation

class MateSettingViewModel {
    weak var coordinator: RunningSettingCoordinator?
    private let runningSettingUseCase: RunningSettingUseCase
    
    init(coordinator: RunningSettingCoordinator, runningSettingUseCase: RunningSettingUseCase) {
        self.coordinator = coordinator
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    func mateDidSelect(nickname: String) {
        self.runningSettingUseCase.updateMateNickname(nickname: nickname)
        self.coordinator?.pushDistanceSettingViewController(
            with: try? self.runningSettingUseCase.runningSetting.value()
        )
    }
}
