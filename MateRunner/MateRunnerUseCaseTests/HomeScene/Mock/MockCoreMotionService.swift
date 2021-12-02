//
//  MockCoreMotionService.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/02.
//

import Foundation

import RxSwift

final class MockCoreMotionService: CoreMotionService {
    func startPedometer() -> Observable<Double> {
        return Observable.just(1)
    }
    
    func startActivity() -> Observable<Double> {
        return Observable.just(1)
    }
    
    func stopPedometer() {}
    
    func stopAcitivity() {}
}
