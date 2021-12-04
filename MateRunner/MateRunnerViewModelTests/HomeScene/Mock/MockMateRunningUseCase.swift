//
//  MockMateRunningUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 김민지 on 2021/12/04.
//

import Foundation

import RxSwift

final class MockMateRunningUseCase: RunningUseCase {
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
        self.runningData.onNext(currentData.makeCopy(myElapsedDistance: 5.223))
        self.isFinished.onNext(false)
    }
    
    func cancelRunningStatus() {}
    
    func executeActivity() {
        guard let currentData = try? self.runningData.value() else { return }
        self.currentMETs = 10
        self.runningData.onNext(currentData.makeCopy(calorie: 20))
    }
    
    func listenRunningSession() {
        guard let currentData = try? self.runningData.value() else { return }
        
        self.runningData.onNext(
            currentData.makeCopy(
                mateRunningRealTimeData: RunningRealTimeData(
                    elapsedDistance: 1.0,
                    elapsedTime: 49000
                )
            )
        )
        
        self.mateProgress.onNext(10)
        self.totalProgress.onNext(60)
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
    
    func executePedometer() { }
    
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
    
    func executePopUpTimer() {}
    
    func invalidateCancelTimer() {}
    
    private func updateProgress(_ progress: BehaviorSubject<Double>, value: Double) {
        guard let targetDistance = self.runningSetting.targetDistance?.kilometer else { return }
        progress.onNext(value / targetDistance.meter)
    }
}
