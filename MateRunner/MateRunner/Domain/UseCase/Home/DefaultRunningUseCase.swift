//
//  DefaultRunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import CoreMotion
import Foundation

import RxSwift

final class DefaultRunningUseCase: RunningUseCase {
    private let pedometer = CMPedometer()
    var distance = BehaviorSubject(value: 0.0)
    var finishRunning = BehaviorSubject(value: false)

    func executePedometer() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                if let distance = pedometerData.distance {
                    guard let newDistance = try? self.distance.value() + distance.doubleValue else { return }
                    self.checkDistance(value: newDistance)
                    self.distance.onNext(self.convertDouble(value: newDistance))
                }
            }
        }
    }
    
    func stopPedometer() {
        self.pedometer.stopUpdates()
    }
}

// MARK: - Private Functions

private extension DefaultRunningUseCase {
    func convertDouble(value: Double) -> Double {
        return round(value/10)/100
    }
    
    func checkDistance(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        if self.convertDouble(value: value) >= 0.05 {
            self.finishRunning.onNext(true)
            self.stopPedometer()
        }
    }
}
