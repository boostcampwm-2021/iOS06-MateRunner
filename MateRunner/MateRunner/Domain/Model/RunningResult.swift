//
//  RunningResult.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/03.
//

import Foundation

class RunningResult: Equatable {
    private(set) var runningID: String
    private(set) var resultOwner: String
    private(set) var runningSetting: RunningSetting
    private(set) var userElapsedDistance: Double = 0
    private(set) var userElapsedTime: Int = 0
    private(set) var calorie: Double = 0
    private(set) var points: [Point] = []
    private(set) var emojis: [String: Emoji]?
    private(set) var isCanceled: Bool = false
    
    init(runningSetting: RunningSetting, userNickname: String) {
        self.runningSetting = runningSetting
        self.runningID = runningSetting.sessionId ?? UUID().uuidString
        self.resultOwner = userNickname
    }
    
    var mode: RunningMode? { return self.runningSetting.mode }
    var targetDistance: Double? { return self.runningSetting.targetDistance }
    var dateTime: Date? { return self.runningSetting.dateTime }
    
    init(
        userNickname: String,
        runningSetting: RunningSetting,
        userElapsedDistance: Double,
        userElapsedTime: Int,
        calorie: Double,
        points: [Point],
        emojis: [String: Emoji]? = nil,
        isCanceled: Bool
    ) {
        self.runningSetting = runningSetting
        self.runningID = runningSetting.sessionId ?? UUID().uuidString
        self.resultOwner = userNickname
        self.userElapsedTime = userElapsedTime
        self.userElapsedDistance = min(
            userElapsedDistance,
            runningSetting.targetDistance ?? userElapsedDistance
        )
        self.calorie = calorie
        self.points = points
        self.emojis = emojis
        self.isCanceled = isCanceled
    }
    
    func updateUserElaspedTime(to newTime: Int) {
        self.userElapsedTime += newTime
    }
    
    func updateElapsedDistance(to newDistance: Double) {
        self.userElapsedDistance += newDistance
    }
    
    func updateCalorie(to newCalorie: Double) {
        self.calorie = newCalorie
    }
    
    func updateEmoji(to newEmojis: [String: Emoji]) {
        self.emojis = newEmojis
    }
    
    func addPoint(_ point: Point) {
        self.points.append(point)
    }
    
    func addEmoji(_ emoji: Emoji, from userNickname: String) {
        if self.emojis == nil { self.emojis = [:] }
        self.emojis?[userNickname] = emoji
    }
    
    func removeEmoji(from userNickname: String) {
        self.emojis?[userNickname] = nil
    }
    
    func cancelRunning() {
        self.isCanceled = true
    }
}

extension RunningResult {
    static func == (lhs: RunningResult, rhs: RunningResult) -> Bool {
        return (
            lhs.runningID == rhs.runningID
            && lhs.resultOwner == rhs.resultOwner
            && lhs.runningSetting == rhs.runningSetting
            && lhs.userElapsedDistance == rhs.userElapsedDistance
            && lhs.userElapsedTime == rhs.userElapsedTime
            && lhs.calorie == rhs.calorie
            && lhs.points == rhs.points
            && lhs.emojis == rhs.emojis
            && lhs.isCanceled == rhs.isCanceled
        )
    }
}
