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
    
    func startPedometer() -> Double {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                if let distance = pedometerData.distance {
                    
                }
            }
        }
        return 0
    }
    
    func stopPedometer() {
        self.pedometer.stopUpdates()
    }
}
