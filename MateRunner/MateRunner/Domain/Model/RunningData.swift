//
//  RunningData.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/08.
//

import Foundation

class RunningData {
    var myRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
    var calorie: Double = 0
}

final class MateModeRunningData: RunningData {
    var mateRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
}
