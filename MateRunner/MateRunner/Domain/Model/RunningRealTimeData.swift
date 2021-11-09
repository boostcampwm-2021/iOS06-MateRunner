//
//  RunningRealTimeData.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/08.
//

import Foundation

import RxSwift

struct RunningRealTimeData {
    var elapsedDistance: BehaviorSubject<Double>
    var elapsedTime: BehaviorSubject<Int>
}

// 기존 모델
// struct RunningRealTimeData {
//    var elapsedDistance: Double
//    var elapsedTime: Int
// }
