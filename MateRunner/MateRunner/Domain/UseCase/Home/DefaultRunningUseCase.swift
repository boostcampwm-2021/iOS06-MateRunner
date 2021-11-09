//
//  DefaultRunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift

final class DefaultRunningUseCase: RunningUseCase {
    private let coreMotionManager = CoreMotionManager()
    private var currentMETs = 0.0
    var runningRealTimeData = RunningData()
    var cancelTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 3)
    var popUpTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 2)
    var inCancelled: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var shouldShowPopUp: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var progress = BehaviorSubject(value: 0.0)
    var finishRunning = BehaviorSubject(value: false)
    private var runningTimeDisposeBag = DisposeBag()
    private var cancelTimeDisposeBag = DisposeBag()
    private var popUpTimeDisposeBag = DisposeBag()
    private var coreMotionManagerDisposeBag = DisposeBag()
    
    func executePedometer() {
        self.coreMotionManager.startPedometer()
            .subscribe(onNext: { [weak self] distance in
                self?.checkDistance(value: distance)
                self?.updateProgress(value: distance)
                self?.runningRealTimeData.myRunningRealTimeData.elapsedDistance.onNext(distance)
            })
            .disposed(by: self.coreMotionManagerDisposeBag)
    }
    
    func executeActivity() {
        self.coreMotionManager.startActivity()
            .subscribe(onNext: { [weak self] mets in
                self?.currentMETs = mets
            })
            .disposed(by: self.coreMotionManagerDisposeBag)
    }
    
    func executeTimer() {
        self.generateTimer()
            .subscribe(onNext: { [weak self] time in
                self?.runningRealTimeData.myRunningRealTimeData.elapsedTime.onNext(time)
                // *Fix : 몸무게 고정 값 나중에 변경해야함
                self?.updateCalorie(weight: 60.0)
            })
            .disposed(by: self.runningTimeDisposeBag)
    }
    
    func executeCancelTimer() {
        self.generateTimer()
            .subscribe(onNext: { [weak self] newTime in
                self?.shouldShowPopUp.onNext(true)
                self?.checkTimeOver(from: newTime, with: 3, emitTarget: self?.cancelTimeLeft) {
                    self?.inCancelled.onNext(true)
                    self?.coreMotionManager.stopPedometer()
                    self?.coreMotionManager.stopAcitivity()
                    self?.cancelTimeDisposeBag = DisposeBag()
                    self?.coreMotionManagerDisposeBag = DisposeBag()
                }
            })
            .disposed(by: self.cancelTimeDisposeBag)
    }
    
    func executePopUpTimer() {
        self.generateTimer()
            .subscribe(onNext: { [weak self] newTime in
                self?.shouldShowPopUp.onNext(true)
                self?.checkTimeOver(from: newTime, with: 2, emitTarget: self?.popUpTimeLeft) {
                    self?.shouldShowPopUp.onNext(false)
                    self?.popUpTimeDisposeBag = DisposeBag()
                }
            })
            .disposed(by: self.popUpTimeDisposeBag)
    }
    
    func invalidateCancelTimer() {
        self.cancelTimeDisposeBag = DisposeBag()
        self.shouldShowPopUp.onNext(false)
        self.cancelTimeLeft.onNext(3)
    }
    
    private func convertToMeter(value: Double) -> Double {
        return value * 1000
    }
    
    private func checkDistance(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        if value >= self.convertToMeter(value: 0.05) {
            self.finishRunning.onNext(true)
            self.coreMotionManager.stopPedometer()
            self.coreMotionManager.stopAcitivity()
            self.coreMotionManagerDisposeBag = DisposeBag()
        }
    }
    
    private func updateProgress(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        self.progress.onNext(value / self.convertToMeter(value: 0.05))
    }
    
    private func updateCalorie(weight: Double) {
        // 1초마다 칼로리 증가량 : 1.08 * METs * 몸무게(kg) * (1/3600)(hr)
        // walking : 3.8METs , running : 10.0METs
        let updateValue = (1.08 * self.currentMETs * weight * (1 / 3600))
        guard let newCalorie = try? self.runningRealTimeData.calorie.value() + updateValue else { return }
        self.runningRealTimeData.calorie.onNext(newCalorie)
    }
    
    private func checkTimeOver(
        from time: Int,
        with limitTime: Int,
        emitTarget: BehaviorSubject<Int>?,
        actionAtLimit: () -> Void
    ) {
        guard let emitTarget = emitTarget else { return }
        emitTarget.onNext(limitTime - time)
        if time >= limitTime {
            actionAtLimit()
        }
    }
    
    private func generateTimer() -> Observable<Int> {
        return Observable<Int>
            .interval(
                RxTimeInterval.seconds(1),
                scheduler: MainScheduler.instance
            )
            .map { $0 + 1 }
    }
}
