//
//  DefaultRunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import CoreMotion
import Foundation

import RxSwift

final class DefaultRunningUseCase {
    var pedometer = CMPedometer()
    var distance = BehaviorSubject(value: 0.0)

    func executePedometer() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                if let distance = pedometerData.distance {
                    let newDistance = try? self.distance.value() + distance.doubleValue
                    self.distance.onNext(self.convertDouble(value: newDistance ?? 0.0))
                }
            }
        }
    }
    
    func stopPedometer() {
        self.pedometer.stopUpdates()
    }
}

private extension DefaultRunningUseCase {
    func convertDouble(value: Double) -> Double {
        return round(value/10)/100
    }
}
