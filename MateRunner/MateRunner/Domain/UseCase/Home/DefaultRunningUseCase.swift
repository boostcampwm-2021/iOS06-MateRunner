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
    var distance = BehaviorSubject(value: 0.0)
    var progress = BehaviorSubject(value: 0.0)
    var finishRunning = BehaviorSubject(value: false)

    func executePedometer() {
        self.coreMotionManager.startPedometer()
            .subscribe(onNext: { [weak self] distance in
                guard let newDistance = try? self?.distance.value() ?? 0.0 + distance else { return }
                self?.checkDistance(value: newDistance)
                self?.updateProgress(value: newDistance)
                self?.distance.onNext(self?.convertToKilometer(value: newDistance) ?? 0.0)
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Private Functions

private extension DefaultRunningUseCase {
    func convertToKilometer(value: Double) -> Double {
        return round(value / 10) / 100
    }
    
    func checkDistance(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        if self.convertToKilometer(value: value) > 0.05 {
            self.finishRunning.onNext(true)
            self.coreMotionManager.stopPedometer()
        }
    }
    
    func updateProgress(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        self.progress.onNext(self.convertToKilometer(value: value) / 0.05)
    }
}
