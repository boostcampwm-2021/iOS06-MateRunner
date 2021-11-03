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
	private(set) var points: [Point] = []
	private(set) var emojis: [String: Emoji] = [:]
	private(set) var isCanceled: Bool = false
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = runningSetting
    }
	
	func updateUserElaspedTime(to newTime: Int) {
		self.userElapsedTime += newTime
	}
	
	func updateElapsedDistance(to newDistance: Double) {
		self.userElapsedDistance += newDistance
	}
	
	func updateKcal(to newKcal: Double) {
		self.kcal = newKcal
	}
	
	func addPoint(_ point: Point) {
		self.points.append(point)
	}
	
	func addEmoji(_ emoji: Emoji, from userNickname: String) {
		self.emojis[userNickname] = emoji
	}
	
	func removeEmoji(from userNickname: String) {
		self.emojis[userNickname] = nil
	}
	
	func cancelRunning() {
		self.isCanceled = true
	}
}
