//
//  Session.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/11.
//

import Foundation

struct Session {
    let sessionId: String
    let host: String
    let mate: String?
    let mode: RunningMode
    let targetDistance: Double
    
    init(runningSetting: RunningSetting) {
        self.sessionId = "session-\(runningSetting.hostNickname)-\(runningSetting.dateTime?.fullDateTimeNumberString() ?? Date().fullDateTimeNumberString())"
        self.host = runningSetting.hostNickname
        self.mate = runningSetting.mateNickname
        self.mode = runningSetting.mode ?? .single
        self.targetDistance = runningSetting.targetDistance ?? 0
    }
}
