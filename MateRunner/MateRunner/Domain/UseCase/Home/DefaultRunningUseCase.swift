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
    private let popUpTimer = RxTimerService()
    private let runningTimer = RxTimerService()
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
                self?.updateDistance(with: distance)
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
        self.runningTimer.start()
            .subscribe(onNext: { [weak self] time in
                self?.updateTime(with: time)
                // *Fix : 몸무게 고정 값 나중에 변경해야함
                self?.updateCalorie(weight: 80.0)
            })
            .disposed(by: self.runningTimer.disposeBag)
    }
    
    func executeCancelTimer() {
        self.shouldShowPopUp.onNext(true)
        self.cancelTimeLeft.onNext(2)
        self.cancelTimer.start()
            .subscribe(onNext: { [weak self] newTime in
                self?.shouldShowPopUp.onNext(true)
                self?.checkTimeOver(from: newTime, with: 2, emitter: self?.cancelTimeLeft) {
                    self?.isCanceled.onNext(true)
                    self?.coreMotionService.stopPedometer()
                    self?.coreMotionService.stopAcitivity()
                    self?.cancelTimer.stop()
                }
            })
            .disposed(by: self.cancelTimer.disposeBag)
    }
    
    func executePopUpTimer() {
        self.shouldShowPopUp.onNext(true)
        self.popUpTimer.start()
            .subscribe(onNext: { [weak self] newTime in
                self?.shouldShowPopUp.onNext(true)
                self?.checkTimeOver(from: newTime, with: 1, emitter: self?.popUpTimeLeft) {
                    self?.shouldShowPopUp.onNext(false)
                    self?.popUpTimer.stop()
                }
            })
            .disposed(by: self.popUpTimer.disposeBag)
    }
    
    func invalidateCancelTimer() {
        self.shouldShowPopUp.onNext(false)
        self.cancelTimeLeft.onNext(3)
        self.cancelTimer.stop()
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
        guard let currentData = try? self.runningData.value() else { return }
        let updatedCalorie = calculateCalorie(of: weight)
        self.runningData.onNext(currentData.makeCopy(calorie: currentData.calorie + updatedCalorie))
    }
    
    private func updateDistance(with newDistance: Double) {
        guard let currentData = try? self.runningData.value() else { return }
        self.runningData.onNext(currentData.makeCopy(myElapsedDistance: newDistance))
    }
    
    private func updateTime(with newTime: Int) {
        guard let currentData = try? self.runningData.value() else { return }
        self.runningData.onNext(currentData.makeCopy(myElapsedTime: newTime))
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
    
    private func calculateCalorie(of weight: Double) -> Double {
        return 1.08 * self.currentMETs * weight * (1 / 3600)
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
