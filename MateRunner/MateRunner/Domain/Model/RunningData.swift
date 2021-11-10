//
//  RunningData.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/08.
//

import Foundation

class RunningData {
    private(set) var myRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
    private(set) var calorie: Double = 0
    
    init() {}
    init(runningData: RunningRealTimeData, calorie: Double) {
        self.myRunningRealTimeData = runningData
        self.calorie = calorie
    }
}

final class MateModeRunningData: RunningData {
    private(set) var mateRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
}
