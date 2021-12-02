//
//  MockSingleRunningUseCase.swift
//  SingleRunningTests
//
//  Created by 전여훈 on 2021/11/06.
//

import Foundation

import RxSwift

final class MockSingleRunningUseCase: RunningUseCase {
    var points: [Point] = []
    var currentMETs: Double = 0.0
    var runningSetting: RunningSetting = RunningSetting()
    var runningData = BehaviorSubject(value: RunningData())
    var isCanceled = BehaviorSubject(value: false)
    var isCanceledByMate = BehaviorSubject(value: false)
    var isFinished = BehaviorSubject(value: false)
    var shouldShowPopUp = BehaviorSubject<Bool>(value: false)
    var myProgress = BehaviorSubject(value: 0.0)
    var mateProgress = BehaviorSubject(value: 0.0)
    var totalProgress = BehaviorSubject(value: 0.0)
    var cancelTimeLeft = PublishSubject<Int>()
    var popUpTimeLeft = PublishSubject<Int>()
    var selfImageURL = PublishSubject<String>()
    var selfWeight = BehaviorSubject<Double>(value: 65)
    var mateImageURL = PublishSubject<String>()
    
    init() {
        self.runningSetting.targetDistance = 10
    }
    
    func loadUserInfo() {
        self.selfImageURL.onNext("test.png")
        self.selfWeight.onNext(70)
    }
    
    func loadMateInfo() {
        self.mateImageURL.onNext("mate.png")
    }
    
    func updateRunningStatus() {
        guard let currentData = try? self.runningData.value() else { return }
        self.myProgress.onNext(50)
        self.runningData.onNext(currentData.makeCopy(myElapsedDistance: 10.1234567))
        self.isFinished.onNext(false)
    }
    
    func cancelRunningStatus() {}
    
    func executeActivity() {
        guard let currentData = try? self.runningData.value() else { return }
        self.currentMETs = 10
        self.runningData.onNext(currentData.makeCopy(calorie: 20))
    }
    
    func listenRunningSession() {
        
    }
    
    func createRunningResult(isCanceled: Bool) -> RunningResult {
        return RunningResult(
            userNickname: "materunner",
            runningSetting: self.runningSetting,
            userElapsedDistance: 0,
            userElapsedTime: 0,
            calorie: 0,
            points: [],
            emojis: nil,
            isCanceled: isCanceled
        )
    }
    
    func executePedometer() {
        
    }
    
    func executeTimer() {
        guard let currentData = try? self.runningData.value() else { return }
        self.runningData.onNext(currentData.makeCopy(myElapsedTime: 10))
        self.runningData.onNext(currentData.makeCopy(myElapsedTime: 49000))
    }
    
    func executeCancelTimer() {
        self.cancelTimeLeft.onNext(3)
        self.shouldShowPopUp.onNext(true)
        self.cancelTimeLeft.onNext(2)
        self.shouldShowPopUp.onNext(true)
        self.cancelTimeLeft.onNext(1)
        self.shouldShowPopUp.onNext(true)
        self.isCanceled.onNext(true)
    }
    
    func executePopUpTimer() {
        
    }
    
    func invalidateCancelTimer() {
        
    }
    
}
