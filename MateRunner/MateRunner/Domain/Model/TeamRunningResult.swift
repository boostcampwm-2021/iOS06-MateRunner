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
	
	override init(runningSetting: RunningSetting) {
		super.init(runningSetting: runningSetting)
	}
    
    init(
        runningSetting: RunningSetting,
        userElapsedDistance: Double,
        userElapsedTime: Int,
        kcal: Double,
        points: [Point],
        emojis: [String: Emoji],
        isCanceled: Bool,
        mateElapsedDistance: Double,
        mateElapsedTime: Int
    ) {
        self.mateElapsedTime = mateElapsedTime
        self.mateElapsedDistance = mateElapsedDistance
        super.init(
            runningSetting: runningSetting,
            userElapsedDistance: userElapsedDistance,
            userElapsedTime: userElapsedTime,
            kcal: kcal,
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
