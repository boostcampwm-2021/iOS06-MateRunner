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
    let mate: String?
    let inviteTime: String
    let mode: RunningMode
    let targetDistance: Double

    init(runningSetting: RunningSetting, host: String) {
        self.mode = runningSetting.mode ?? .team
        self.targetDistance = runningSetting.targetDistance ?? 0
        self.inviteTime = Date().fullDateTimeNumberString()
        self.host = host
        self.mate = runningSetting.mateNickname
        self.sessionId = runningSetting.sessionId ?? ""
    }

    init(sessionId: String,
         host: String,
         inviteTime: String,
         mode: RunningMode,
         targetDistance: Double,
         mate: String? = nil) {
        self.sessionId = sessionId
        self.host = host
        self.inviteTime = inviteTime
        self.mode = mode
        self.targetDistance = targetDistance
        self.mate = mate
    }
    
    init?(from dictionary: [AnyHashable: Any]) {
        guard let sessionId = dictionary["sessionId"] as? String,
              let host = dictionary["host"] as? String,
              let mate = dictionary["mate"] as? String,
              let inviteTime = dictionary["inviteTime"] as? String,
              let modeString = dictionary["mode"] as? String,
              let mode = RunningMode.init(rawValue: modeString),
              let targetDistanceString = dictionary["targetDistance"] as? String,
              let targetDistance = Double(targetDistanceString) else {
                  return nil
              }
        self.init(sessionId: sessionId,
                  host: host,
                  inviteTime: inviteTime,
                  mode: mode,
                  targetDistance: targetDistance,
                  mate: mate)
    }

    func toRunningSetting() -> RunningSetting {
        return RunningSetting(
            sessionId: self.sessionId,
            mode: self.mode,
            targetDistance: self.targetDistance,
            hostNickname: self.mate,
            mateNickname: self.host,
            dateTime: nil
        )
    }
}
