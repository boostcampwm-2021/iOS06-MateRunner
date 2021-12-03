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
    var mateIsRunning = PublishSubject<Bool>()
    private let userRepository: UserRepository
    private let runningRepository: RunningRepository
    private let disposeBag = DisposeBag()
    
    init(
        runningSetting: RunningSetting,
        userRepository: UserRepository,
        runningRepository: RunningRepository
    ) {
        self.runningSetting = BehaviorSubject(value: runningSetting)
        self.userRepository = userRepository
        self.runningRepository = runningRepository
    }
    
    func updateHostNickname() {
        guard var newSetting = try? self.runningSetting.value(),
              let userNickname = self.userRepository.fetchUserNickname() else { return }
        newSetting.hostNickname = userNickname
        self.runningSetting.onNext(newSetting)
    }
    
    func updateSessionId() {
        guard var newSetting = try? self.runningSetting.value(),
              let userNickname = self.userRepository.fetchUserNickname() else { return }
        newSetting.sessionId = createSessionId(with: userNickname, of: Date())
        self.runningSetting.onNext(newSetting)
    }
    
    private func createSessionId(with userNickname: String, of date: Date) -> String {
        return "session-\(date.fullDateTimeNumberString())-\(userNickname)"
    }
    
    func updateMode(mode: RunningMode) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.mode = mode
        self.runningSetting.onNext(newSetting)
    }
    
    func updateTargetDistance(distance: Double) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.targetDistance = distance
        self.runningSetting.onNext(newSetting)
    }
    
    func deleteMateNickname() {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.mateNickname = nil
        self.runningSetting.onNext(newSetting)
    }
    
    func updateMateNickname(nickname: String) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        self.runningRepository.fetchRunningStatus(of: nickname)
            .subscribe(onNext: { isRunning in
                self.mateIsRunning.onNext(isRunning)
                if !isRunning {
                    newSetting.mateNickname = nickname
                    self.runningSetting.onNext(newSetting)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateDateTime(date: Date) {
        guard var newSetting = try? self.runningSetting.value() else { return }
        newSetting.dateTime = date
        self.runningSetting.onNext(newSetting)
    }
}
