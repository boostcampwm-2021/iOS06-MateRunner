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
    private let disposeBag = DisposeBag()
    private var currentMETs = 0.0
    var distance = BehaviorSubject(value: 0.0)
    var progress = BehaviorSubject(value: 0.0)
    var calories = BehaviorSubject(value: 0.0)
    var finishRunning = BehaviorSubject(value: false)

    func executePedometer() {
        self.coreMotionManager.startPedometer()
            .subscribe(onNext: { [weak self] distance in
                self?.checkDistance(value: distance)
                self?.updateProgress(value: distance)
                self?.distance.onNext(distance)
            })
            .disposed(by: self.disposeBag)
    }
    
    func executeActivity() {
        self.coreMotionManager.startActivity()
            .subscribe(onNext: { mets in
                self.currentMETs = mets
            })
            .disposed(by: self.disposeBag)
    }
    
    private func convertToMeter(value: Double) -> Double {
        return value * 1000
    }
    
    private func checkDistance(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        if value >= self.convertToMeter(value: 0.05) {
            self.finishRunning.onNext(true)
            self.coreMotionManager.stopPedometer()
        }
    }
    
    private func updateProgress(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        self.progress.onNext(value / self.convertToMeter(value: 0.05))
    }
    
    private func updateCalorie(weight: Double) {
        // 1초마다 실행되어야 함
        // 1초마다 칼로리 증가량 : 1.08 * METs * 몸무게(kg) * (1/3600)(hr)
        // walking : 3.8METs , running : 10.0METs
        // *Fix : 몸무게 고정 값 나중에 변경해야함
        let updateValue = (1.08 * self.currentMETs * weight * (1 / 3600))
        guard let calorie = try? self.calories.value() + updateValue else { return }
        self.calories.onNext(calorie)
    }
}
