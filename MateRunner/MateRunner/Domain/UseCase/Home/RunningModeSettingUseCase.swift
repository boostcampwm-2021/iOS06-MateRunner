//
//  RunningModeSettingUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/03.
//

import Foundation

import RxSwift

final class RunningModeSettingUseCase {
    var runningSetting = BehaviorSubject<RunningSetting>(value: RunningSetting())
    
    func setMode(mode: RunningMode) {
        var new = RunningSetting()
        new.mode = mode
        self.runningSetting.on(.next(new))
    }
}
