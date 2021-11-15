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
    var runningSetting: RunningSetting
    var runningData: BehaviorSubject<RunningData> = BehaviorSubject(value: RunningData())
    var points: [Point] = []
    
    var cancelTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 3)
    var popUpTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 2)
    var inCancelled: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var shouldShowPopUp: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var progress = BehaviorSubject(value: 0.0)
    var finishRunning = BehaviorSubject(value: false)
    
    private var runningTimeDisposeBag = DisposeBag()
    private var cancelTimeDisposeBag = DisposeBag()
    private var popUpTimeDisposeBag = DisposeBag()
    private var coreMotionServiceDisposeBag = DisposeBag()
    private let coreMotionService = CoreMotionService()
    private var currentMETs = 0.0
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = runningSetting
    }
    
    func executePedometer() {
        self.coreMotionService.startPedometer()
            .subscribe(onNext: { [weak self] distance in
                self?.isFinished(value: distance)
                self?.updateProgress(value: distance)
                self?.updateDistance(value: distance)
            })
            .disposed(by: self.coreMotionServiceDisposeBag)
    }
    
    func executeActivity() {
        self.coreMotionService.startActivity()
            .subscribe(onNext: { [weak self] mets in
                self?.currentMETs = mets
            })
            .disposed(by: self.coreMotionServiceDisposeBag)
    }
    
    func executeTimer() {
        self.generateTimer()
            .subscribe(onNext: { [weak self] time in
                self?.updateTime(value: time)
                // *Fix : 몸무게 고정 값 나중에 변경해야함
                self?.updateCalorie(weight: 80.0)
            })
            .disposed(by: self.runningTimeDisposeBag)
    }
    
    func executeCancelTimer() {
        self.generateTimer()
            .subscribe(onNext: { [weak self] newTime in
                self?.shouldShowPopUp.onNext(true)
                self?.checkTimeOver(from: newTime, with: 3, emitTarget: self?.cancelTimeLeft) {
                    self?.inCancelled.onNext(true)
                    self?.coreMotionService.stopPedometer()
                    self?.coreMotionService.stopAcitivity()
                    self?.cancelTimeDisposeBag = DisposeBag()
                    self?.coreMotionServiceDisposeBag = DisposeBag()
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
    
    private func isFinished(value: Double) {
        guard let targetDistance = self.runningSetting.targetDistance,
              value >= self.convertToMeter(value: targetDistance) else { return }
        self.finishRunning.onNext(true)
        self.coreMotionService.stopPedometer()
        self.coreMotionService.stopAcitivity()
        self.coreMotionServiceDisposeBag = DisposeBag()
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
    
    func createRunningResult(isCanceled: Bool) -> RunningResult {
        guard let runningData = try? self.runningData.value() else {
            return RunningResult(runningSetting: self.runningSetting)
        }
        return RunningResult(
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: [],
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
        print(self.points)
    }
}
