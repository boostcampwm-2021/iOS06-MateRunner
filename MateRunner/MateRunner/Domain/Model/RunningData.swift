//
//  RunningData.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/08.
//

import Foundation

import RxSwift

class RunningData {
    var myRunningRealTimeData = RunningRealTimeData(elapsedDistance: BehaviorSubject(value: 0.0),
                                                    elapsedTime: BehaviorSubject(value: 0))
    var calorie: BehaviorSubject<Double> = BehaviorSubject(value: 0.0)
}

final class MateModeRunningData: RunningData {
    var mateRunningRealTimeData = RunningRealTimeData(elapsedDistance: BehaviorSubject(value: 0.0),
                                                      elapsedTime: BehaviorSubject(value: 0))
}

// 기존 모델
// class RunningData {
//    private(set) var myRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
//    private(set) var calorie: Double = 0
// }
//
// final class MateModeRunningData: RunningData {
//    private(set) var mateRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
// }
