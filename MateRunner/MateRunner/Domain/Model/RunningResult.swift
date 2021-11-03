//
//  RunningResult.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/03.
//

import Foundation

class RunningResult {
    private let runningSetting: RunningSetting
    private(set) var userElapsedDistance: Double = 0
    private(set) var userElapsedTime: Int = 0
    private(set) var kcal: Double = 0
    private(set) var points = [Point]()
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = runningSetting
    }
}
