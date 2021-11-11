//
//  Invitation.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/11.
//

import Foundation

struct Invitation: Codable {
    let sessionId: String
    let host: String
    let inviteTime: String
    let mode: RunningMode
    let targetDistance: Double
    
    init(runningSetting: RunningSetting, host: String) {
        self.mode = runningSetting.mode ?? .team
        self.targetDistance = runningSetting.targetDistance ?? 0
        self.inviteTime = runningSetting.dateTime?.fullDateTimeNumberString() ?? Date().fullDateTimeNumberString()
        self.host = host
        self.sessionId = "session-\(host)-\(runningSetting.dateTime?.fullDateTimeNumberString() ?? Date().fullDateTimeNumberString())"
    }
    
    init(sessionId: String, host: String, inviteTime: String, mode: RunningMode, targetDistance: Double) {
        self.sessionId = sessionId
        self.host = host
        self.inviteTime = inviteTime
        self.mode = mode
        self.targetDistance = targetDistance
    }
}
