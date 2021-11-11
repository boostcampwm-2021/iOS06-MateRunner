//
//  DefaultRunningSettingUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/03.
//

import Foundation

import RxSwift

final class DefaultRunningSettingUseCase: RunningSettingUseCase {
    var runningSetting: BehaviorSubject<RunningSetting>
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = BehaviorSubject(value: runningSetting)
    }
    
    func updateHost() {
        // TODO: 유저 아이디 불러와서 host 설정
    }
    
    func updateMode(mode: RunningMode) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.mode = mode
        self.runningSetting.on(.next(newSetting))
    }
    
    func updateTargetDistance(distance: Double) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.targetDistance = distance
        self.runningSetting.on(.next(newSetting))
    }
    
    func updateMateNickname(nickname: String) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.mateNickname = nickname
        self.runningSetting.on(.next(newSetting))
    }
    
    func updateDateTime(date: Date) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.dateTime = date
        self.runningSetting.on(.next(newSetting))
    }
}
