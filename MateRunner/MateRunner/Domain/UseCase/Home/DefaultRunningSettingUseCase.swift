//
//  DefaultRunningSettingUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/03.
//

import Foundation

import RxSwift

final class DefaultRunningSettingUseCase: RunningSettingUseCase {
    var runningSetting = BehaviorSubject(value: RunningSetting())
    
    func updateMode(mode: RunningMode) {
        var newSetting = RunningSetting()
        newSetting.mode = mode
        self.runningSetting.on(.next(newSetting))
    }
    
    func updateTargetDistance(distance: Double) {
        var newSetting = RunningSetting()
        newSetting.targetDistance = distance
        self.runningSetting.on(.next(newSetting))
    }
    
    func updateMateNickname(nickname: String) {
        var newSetting = RunningSetting()
        newSetting.mateNickname = nickname
        self.runningSetting.on(.next(newSetting))
    }
    
    func updateDateTime(date: Date) {
        var newSetting = RunningSetting()
        newSetting.dateTime = date
        self.runningSetting.on(.next(newSetting))
    }
}
