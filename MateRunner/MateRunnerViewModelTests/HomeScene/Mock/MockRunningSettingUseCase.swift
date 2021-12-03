//
//  MockRunningSettingUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/11/30.
//

import Foundation

import RxSwift

class MockRunningSettingUseCase: RunningSettingUseCase {
    var runningSetting: BehaviorSubject<RunningSetting>
    var mateIsRunning: PublishSubject<Bool> = PublishSubject<Bool>()
    
    private var dummyRunnningSetting = RunningSetting(
        sessionId: "dummy-session",
        mode: .single,
        targetDistance: 10.0,
        hostNickname: "host",
        mateNickname: "mate",
        dateTime: Date()
    )
    
    init() {
        self.runningSetting = BehaviorSubject<RunningSetting>(value: self.dummyRunnningSetting)
    }
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = BehaviorSubject<RunningSetting>(value: runningSetting)
    }
    
    func updateHostNickname() {
        self.runningSetting.onNext(self.dummyRunnningSetting)
    }
    
    func updateSessionId() {
        self.runningSetting.onNext(self.dummyRunnningSetting)
    }
    
    func deleteMateNickname() {
        self.runningSetting.onNext(self.dummyRunnningSetting)
    }
    
    func updateMode(mode: RunningMode) {
        self.runningSetting.onNext(
            RunningSetting(
                sessionId: "dummy-session",
                mode: mode,
                targetDistance: 10.0,
                hostNickname: "host",
                mateNickname: "mate",
                dateTime: Date()
            )
        )
    }
    
    func updateTargetDistance(distance: Double) {
        self.runningSetting.onNext(
            RunningSetting(
                sessionId: "dummy-session",
                mode: .single,
                targetDistance: distance,
                hostNickname: "host",
                mateNickname: "mate",
                dateTime: Date()
            )
        )
    }
    
    func updateMateNickname(nickname: String) {
        self.runningSetting.onNext(
            RunningSetting(
                sessionId: "dummy-session",
                mode: .single,
                targetDistance: 10.0,
                hostNickname: "host",
                mateNickname: nickname,
                dateTime: Date()
            )
        )
        nickname == "running"
        ? self.mateIsRunning.onNext(true)
        : self.mateIsRunning.onNext(false)
    }
    
    func updateDateTime(date: Date) {
        self.runningSetting.onNext(
            RunningSetting(
                sessionId: "dummy-session",
                mode: .single,
                targetDistance: 10.0,
                hostNickname: "host",
                mateNickname: "mate",
                dateTime: date
            )
        )
    }
    
}
