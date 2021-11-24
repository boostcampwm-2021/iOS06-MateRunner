//
//  TeamRunningResult.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

final class TeamRunningResult: RunningResult {
	private(set) var mateElapsedDistance: Double = 0
	private(set) var mateElapsedTime: Int = 0
	
	var totalDistance: Double {
		return self.userElapsedDistance + self.mateElapsedDistance
	}
	var contribution: Double {
		return self.userElapsedDistance / self.totalDistance
	}
    
    init(
        userNickname: String,
        runningSetting: RunningSetting,
        userElapsedDistance: Double,
        userElapsedTime: Int,
        calorie: Double,
        points: [Point],
        emojis: [String: Emoji]? = nil,
        isCanceled: Bool,
        mateElapsedDistance: Double,
        mateElapsedTime: Int
    ) {
        self.mateElapsedTime = mateElapsedTime
        self.mateElapsedDistance = mateElapsedDistance
        super.init(
            userNickname: userNickname,
            runningSetting: runningSetting,
            userElapsedDistance: userElapsedDistance,
            userElapsedTime: userElapsedTime,
            calorie: calorie,
            points: points,
            emojis: emojis,
            isCanceled: isCanceled
        )
    }
	
	func updateMateElaspedTime(to newTime: Int) {
		self.mateElapsedTime += newTime
	}
	
	func updateMateElapsedDistance(to newDistance: Double) {
		self.mateElapsedDistance += newDistance
	}
}
