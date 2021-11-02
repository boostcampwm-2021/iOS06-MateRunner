//
//  RunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import CoreLocation

import RxCocoa
import RxSwift

let mockRunnigResult = RunningResult()

final class RunningResultUseCase {
    func getRunningResult() -> RunningResult {
        return mockRunnigResult
    }
}

// class로 구현해서 상속? struct로 구현해서 내부에 mode 프로퍼티?
class RunningResult {
    private(set) var dateTime: Date = Date()
    private(set) var targetDistance: Double = 0
    private(set) var userDistance: Double = 0
    private(set) var kcal: Int = 0
    private(set) var userTime: Int = 0
    private(set) var points: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2DMake(35.67257168, 125.0),
        CLLocationCoordinate2DMake(37.67256334, 126.80336139),
        CLLocationCoordinate2DMake(37.99999999, 126.99999999)
    ]
}

class SingleRunningResult: RunningResult {
    
}
