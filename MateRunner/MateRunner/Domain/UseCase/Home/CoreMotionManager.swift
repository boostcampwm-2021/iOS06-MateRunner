//
//  CoreMotionManager.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/06.
//

import CoreMotion
import Foundation

import RxSwift

final class CoreMotionManager {
    private let pedometer = CMPedometer()
    
    func startPedometer(escapingHandler : @escaping (Double) -> Void) {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                if let distance = pedometerData.distance {
                    escapingHandler(distance.doubleValue)
                }
            }
        }
    }
    
    func stopPedometer() {
        self.pedometer.stopUpdates()
    }
}
