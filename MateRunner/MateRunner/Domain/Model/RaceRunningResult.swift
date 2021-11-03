//
//  RaceRunningResult.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

final class RaceRunningResult: RunningResult {
	private(set) var mateElapsedDistance: Double = 0
	private(set) var mateElapsedTime: Int = 0
	
	var isUserWinner: Bool {
		return self.userElapsedDistance >= self.mateElapsedDistance
	}
	
	override init(runningSetting: RunningSetting) {
		super.init(runningSetting: runningSetting)
	}
	
	func updateMateElaspedTime(to newTime: Int) {
		self.mateElapsedTime += newTime
	}
	
	func updateMateDistance(to newDistance: Double) {
		self.mateElapsedDistance += newDistance
	}
}
