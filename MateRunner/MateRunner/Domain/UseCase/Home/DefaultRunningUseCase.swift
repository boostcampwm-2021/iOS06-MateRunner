//
//  DefaultRunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import CoreLocation
import Foundation

import RxSwift

final class DefaultRunningUseCase: RunningUseCase {
    private var points: [Point]
    private var currentMETs = 0.0
    
    var runningSetting: RunningSetting
    var runningData: BehaviorSubject<RunningData>
    var isCanceled: BehaviorSubject<Bool>
    var isFinished: BehaviorSubject<Bool>
    var shouldShowPopUp: BehaviorSubject<Bool>
    var progress: BehaviorSubject<Double>
    var cancelTimeLeft: PublishSubject<Int>
    var popUpTimeLeft: PublishSubject<Int>
    
    private var disposeBag = DisposeBag()
    private let cancelTimer = RxTimerService()
    private let coreMotionService = CoreMotionService()
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = runningSetting
        self.points = []
        self.runningData = BehaviorSubject(value: RunningData())
        self.isCanceled  = BehaviorSubject(value: false)
        self.isFinished = BehaviorSubject(value: false)
        self.shouldShowPopUp = BehaviorSubject<Bool>(value: false)
        self.progress = BehaviorSubject(value: 0.0)
        self.cancelTimeLeft = PublishSubject<Int>()
        self.popUpTimeLeft = PublishSubject<Int>()
    }
    
    func executePedometer() {
        self.coreMotionService.startPedometer()
            .subscribe(onNext: { [weak self] distance in
                self?.checkRunningShouldFinish(value: distance)
                self?.updateProgress(value: distance)
                self?.updateDistance(value: distance)
            })
            .disposed(by: self.disposeBag)
    }
    
    func executeActivity() {
        self.coreMotionService.startActivity()
            .subscribe(onNext: { [weak self] mets in
                self?.currentMETs = mets
            })
            .disposed(by: self.disposeBag)
    }
    
    func executeTimer() {
        let timer = RxTimerService()
        timer.start()
            .subscribe(onNext: { [weak self] time in
                self?.updateTime(value: time)
                // *Fix : 몸무게 고정 값 나중에 변경해야함
                self?.updateCalorie(weight: 80.0)
            })
            .disposed(by: timer.disposeBag)
    }
    
    func executeCancelTimer() {
        self.cancelTimer.start()
            .subscribe(onNext: { [weak self] newTime in
                self?.shouldShowPopUp.onNext(true)
                self?.checkTimeOver(from: newTime, with: 3, emitter: self?.cancelTimeLeft) {
                    self?.isCanceled.onNext(true)
                    self?.coreMotionService.stopPedometer()
                    self?.coreMotionService.stopAcitivity()
                    self?.cancelTimer.stop()
                }
            })
            .disposed(by: self.cancelTimer.disposeBag)
    }
    
    func executePopUpTimer() {
        let timer = RxTimerService()
        timer.start()
            .subscribe(onNext: { [weak self] newTime in
                self?.shouldShowPopUp.onNext(true)
                self?.checkTimeOver(from: newTime, with: 2, emitter: self?.popUpTimeLeft) {
                    self?.shouldShowPopUp.onNext(false)
                    timer.stop()
                }
            })
            .disposed(by: timer.disposeBag)
    }
    
    func invalidateCancelTimer() {
        self.shouldShowPopUp.onNext(false)
        self.cancelTimer.stop()
    }
    
    private func convertToMeter(value: Double) -> Double {
        return value * 1000
    }
    
    private func checkRunningShouldFinish(value: Double) {
        guard let targetDistance = self.runningSetting.targetDistance,
              value >= self.convertToMeter(value: targetDistance) else { return }
        self.isFinished.onNext(true)
        self.coreMotionService.stopPedometer()
        self.coreMotionService.stopAcitivity()
    }
    
    private func updateProgress(value: Double) {
        guard let targetDistance = self.runningSetting.targetDistance else { return }
        self.progress.onNext(value / self.convertToMeter(value: targetDistance))
    }
    
    private func updateCalorie(weight: Double) {
        // 1초마다 칼로리 증가량 : 1.08 * METs * 몸무게(kg) * (1/3600)(hr)
        // walking : 3.8METs , running : 10.0METs
        let updateCalorie = (1.08 * self.currentMETs * weight * (1 / 3600))
        guard let currentData = try? self.runningData.value() else { return }
        let currentTime = currentData.myElapsedTime
        let currentDistance = currentData.myElapsedDistance
        let newCalorie = currentData.calorie + updateCalorie
        let newData = RunningRealTimeData(elapsedDistance: currentDistance, elapsedTime: currentTime)
        let newRunningData = RunningData(runningData: newData, calorie: newCalorie)
        self.runningData.onNext(newRunningData)
    }
    
    private func updateDistance(value: Double) {
        guard let currentData = try? self.runningData.value() else { return }
        let currentTime = currentData.myElapsedTime
        let currentCalorie = currentData.calorie
        let newData = RunningRealTimeData(elapsedDistance: value, elapsedTime: currentTime)
        let newRunningData = RunningData(runningData: newData, calorie: currentCalorie)
        self.runningData.onNext(newRunningData)
    }
    
    private func updateTime(value: Int) {
        guard let currentData = try? self.runningData.value() else { return }
        let currentCalorie = currentData.calorie
        let currentDistance = currentData.myElapsedDistance
        let newData = RunningRealTimeData(elapsedDistance: currentDistance, elapsedTime: value)
        let newRunningData = RunningData(runningData: newData, calorie: currentCalorie)
        self.runningData.onNext(newRunningData)
    }
    
    private func checkTimeOver(
        from time: Int,
        with limitTime: Int,
        emitter: PublishSubject<Int>?,
        actionAtLimit: () -> Void
    ) {
        guard let emitTarget = emitter else { return }
        emitTarget.onNext(limitTime - time)
        if time >= limitTime {
            actionAtLimit()
        }
    }
    
    func createRunningResult(isCanceled: Bool) -> RunningResult {
        guard let runningData = try? self.runningData.value() else {
            return RunningResult(runningSetting: self.runningSetting)
        }
        return RunningResult(
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: self.points,
            emojis: [:],
            isCanceled: isCanceled
        )
    }
}

extension DefaultRunningUseCase: LocationDidUpdateDelegate {
    func locationDidUpdate(_ location: CLLocation) {
        self.points.append(Point(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        ))
    }
}
