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
    var distance = BehaviorSubject(value: 0.0)
    var finishRunning = BehaviorSubject(value: false)

    func executePedometer() {
        self.coreMotionManager.startPedometer { distance in
            guard let newDistance = try? self.distance.value() + distance else { return }
            self.checkDistance(value: newDistance)
            self.distance.onNext(self.convertToKilometer(value: newDistance))
        }
    }
}

// MARK: - Private Functions

private extension DefaultRunningUseCase {
    func convertToKilometer(value: Double) -> Double {
        return round(value/10)/100
    }
    
    func checkDistance(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        if self.convertToKilometer(value: value) > 0.05 {
            self.finishRunning.onNext(true)
            self.coreMotionManager.stopPedometer()
        }
    }
}
