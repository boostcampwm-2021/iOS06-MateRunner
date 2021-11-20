//
//  RunningResultFactory.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/21.
//

import Foundation

class RunningResultFactory {
    private let runningSetting: RunningSetting
    private let runningData: RunningData
    private let points: [Point]
    private let isCanceled: Bool
    
    init(runningSetting: RunningSetting, runningData: RunningData, points: [Point], isCanceled: Bool) {
        self.runningSetting = runningSetting
        self.runningData = runningData
        self.points = points
        self.isCanceled = isCanceled
    }
    
    func createResult(of mode: RunningMode) -> RunningResult {
        switch mode {
        case .single:
            return self.createSingleRunningResult()
        case .race:
            return self.createRaceRunningResult()
        case .team:
            return self.createTeamRunningResult()
        }
    }
    
    private func createSingleRunningResult() -> RunningResult {
        return RunningResult(
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: self.points,
            emojis: [:],
            isCanceled: isCanceled
        )
    }
    
    private func createRaceRunningResult() -> RunningResult {
        return RaceRunningResult(
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: self.points,
            emojis: [:],
            isCanceled: isCanceled,
            mateElapsedDistance: runningData.mateElapsedDistance,
            mateElapsedTime: runningData.mateElapsedTime
        )
    }
    
    private func createTeamRunningResult() -> RunningResult {
        return TeamRunningResult(
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: self.points,
            emojis: [:],
            isCanceled: isCanceled,
            mateElapsedDistance: runningData.mateElapsedDistance,
            mateElapsedTime: runningData.mateElapsedTime
        )
    }
}
