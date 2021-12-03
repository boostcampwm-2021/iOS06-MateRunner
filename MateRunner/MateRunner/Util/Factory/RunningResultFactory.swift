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
    private let userNickname: String
    
    init(
        userNickname: String,
        runningSetting: RunningSetting,
        runningData: RunningData,
        points: [Point],
        isCanceled: Bool
    ) {
        self.userNickname = userNickname
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
            userNickname: self.userNickname,
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: self.points,
            isCanceled: isCanceled
        )
    }
    
    private func createRaceRunningResult() -> RunningResult {
        return RaceRunningResult(
            userNickname: self.userNickname,
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: self.points,
            isCanceled: isCanceled,
            mateElapsedDistance: runningData.mateElapsedDistance,
            mateElapsedTime: runningData.mateElapsedTime
        )
    }
    
    private func createTeamRunningResult() -> RunningResult {
        return TeamRunningResult(
            userNickname: self.userNickname,
            runningSetting: self.runningSetting,
            userElapsedDistance: runningData.myElapsedDistance,
            userElapsedTime: runningData.myElapsedTime,
            calorie: runningData.calorie,
            points: self.points,
            isCanceled: isCanceled,
            mateElapsedDistance: runningData.mateElapsedDistance,
            mateElapsedTime: runningData.mateElapsedTime
        )
    }
}
