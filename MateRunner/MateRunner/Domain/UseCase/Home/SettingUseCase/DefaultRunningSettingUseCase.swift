//
//  DefaultRunningSettingUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/03.
//

import Foundation

import RxSwift

final class DefaultRunningSettingUseCase: RunningSettingUseCase {
    private let userRepository: UserRepository
    var runningSetting: BehaviorSubject<RunningSetting>
    
    init(runningSetting: RunningSetting, userRepository: UserRepository) {
        self.runningSetting = BehaviorSubject(value: runningSetting)
        self.userRepository = userRepository
    }
    
    func updateHostNickname() {
        guard var newSetting = try? self.runningSetting.value(),
              let userNickname = self.userRepository.fetchUserNickname() else { return }
        newSetting.hostNickname = userNickname
        self.runningSetting.on(.next(newSetting))
    }
    
    func updateSessionId() {
        guard var newSetting = try? self.runningSetting.value(),
              let userNickname = self.userRepository.fetchUserNickname() else { return }
        newSetting.sessionId = createSessionId(with: userNickname)
        self.runningSetting.on(.next(newSetting))
    }
    
    private func createSessionId(with userNickname: String) -> String {
        return "session-\(userNickname)-\(Date().fullDateTimeNumberString())"
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
