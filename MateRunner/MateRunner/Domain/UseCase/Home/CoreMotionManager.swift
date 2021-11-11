//
//  CoreMotionManager.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/06.
//

import CoreMotion
import Foundation

import RxCocoa
import RxSwift

final class CoreMotionManager {
    private let pedometer = CMPedometer()
    private let activityManager = CMMotionActivityManager()

    func startPedometer() -> Observable<Double> {
        return BehaviorRelay<Double>.create { [weak self] observe in
            self?.pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                if let distance = pedometerData.distance {
                    observe.onNext(distance.doubleValue)
                }
            }
            return Disposables.create()
        }
    }
    
    func startActivity() -> Observable<Double> {
        return BehaviorRelay<Double>.create { [weak self] observe in
            self?.activityManager.startActivityUpdates(to: .current ?? .main) { activity in
                guard let activity = activity else { return }
                if activity.stationary {
                    observe.onNext(Mets.stationary.value())
                }
                if activity.walking {
                    observe.onNext(Mets.walking.value())
                }
                if activity.running {
                    observe.onNext(Mets.running.value())
                }
            }
            return Disposables.create()
        }
    }
    
    func stopPedometer() {
        self.pedometer.stopUpdates()
    }
    
    func stopAcitivity() {
        self.activityManager.stopActivityUpdates()
    }
}
