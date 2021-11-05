//
//  DefaultRunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import CoreMotion
import Foundation

import RxSwift

class DefaultRunningUseCase {
    var pedometer = CMPedometer()
    var distance = BehaviorSubject(value: 0.0)

    func executePedometer() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                if let distance = pedometerData.distance {
                    let newDistance = try? self.distance.value() + distance.doubleValue
                    self.distance.onNext(newDistance ?? 0.0)
                }
            }
        }
    }
}
