//
//  RunningData.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/08.
//

import Foundation
import RxSwift

class RunningData {
    private(set) var myRunningRealTimeData: RunningRealTimeData
    private(set) var mateRunningRealTimeData: RunningRealTimeData
    private(set) var calorie: Double
    
    var myElapsedDistance: Double {
        return self.myRunningRealTimeData.elapsedDistance
    }
    
    var myElapsedTime: Int {
        return self.myRunningRealTimeData.elapsedTime
    }
    
    init() {
        self.myRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
        self.mateRunningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
        self.calorie = 0
    }
    
    init(myRunningRealTimeData: RunningRealTimeData,
         mateRunningRealTimeData: RunningRealTimeData,
         calorie: Double) {
        self.myRunningRealTimeData = myRunningRealTimeData
        self.mateRunningRealTimeData = mateRunningRealTimeData
        self.calorie = calorie
    }
    
    var mateElapsedDistance: Double {
        return self.mateRunningRealTimeData.elapsedDistance
    }
    
    var mateElapsedTime: Int {
        return self.mateRunningRealTimeData.elapsedTime
    }
    
    var totalElapsedDistance: Double {
        return (self.mateElapsedDistance + self.myElapsedDistance)
    }
    
    func makeCopy(mateRunningRealTimeData: RunningRealTimeData) -> RunningData {
        return RunningData(myRunningRealTimeData: self.myRunningRealTimeData,
                           mateRunningRealTimeData: mateRunningRealTimeData,
                           calorie: self.calorie)
    }
    
    func makeCopy(
        myElapsedDistance: Double? = nil,
        myElapsedTime: Int? = nil,
        calorie: Double? = nil
    ) -> RunningData {
        return RunningData(
            myRunningRealTimeData: RunningRealTimeData(
                elapsedDistance: myElapsedDistance ?? self.myElapsedDistance,
                elapsedTime: myElapsedTime ?? self.myElapsedTime
            ),
            mateRunningRealTimeData: self.mateRunningRealTimeData,
            calorie: calorie ?? self.calorie
        )
    }
}
