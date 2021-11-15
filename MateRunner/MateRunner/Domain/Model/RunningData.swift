//
//  RunningData.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/08.
//

import Foundation

class RunningData {
    private(set) var myRunningRealTimeData: RunningRealTimeData
    private(set) var calorie: Double
    
    var myElapsedDistance: Double {
        return self.myRunningRealTimeData.elapsedDistance
    }
    
    var myElapsedTime: Int {
        return self.myRunningRealTimeData.elapsedTime
    }
    
    init() {
        self.myRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
        self.calorie = 0
    }
    
    init(realTimeData: RunningRealTimeData, calorie: Double) {
        self.myRunningRealTimeData = realTimeData
        self.calorie = calorie
    }
    
    func makeCopy(
        myElapsedDistance: Double? = nil,
        myElapsedTime: Int? = nil,
        calorie: Double? = nil
    ) -> RunningData {
        return RunningData(
            realTimeData: RunningRealTimeData(
                elapsedDistance: myElapsedDistance ?? self.myElapsedDistance,
                elapsedTime: myElapsedTime ?? self.myElapsedTime
            ),
            calorie: calorie ?? self.calorie
        )
    }
}

final class MateModeRunningData: RunningData {
    private(set) var mateRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
    
    var mateElapsedDistance: Double {
        return self.mateRunningRealTimeData.elapsedDistance
    }
    
    var mateElapsedTime: Int {
        return self.mateRunningRealTimeData.elapsedTime
    }
}
