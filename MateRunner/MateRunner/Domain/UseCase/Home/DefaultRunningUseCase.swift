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
        print(CMPedometer.isStepCountingAvailable())
        if CMPedometer.isStepCountingAvailable() {
            print("?")
            pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                
                DispatchQueue.main.async {
                    print(pedometerData.numberOfSteps.intValue)
                }
            }
        }
    }
}
