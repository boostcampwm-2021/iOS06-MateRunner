//
//  NotificationCenterKey.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/28.
//

import Foundation

enum NotificationCenterKey {
    static let invitationDidReceive = Notification.Name("invitationDidReceive")
    static let invitation = "invitation"
    static let sessionID = "sessionId"
    static let host = "host"
    static let mate = "mate"
    static let inviteTime = "inviteTime"
    static let mode = "mode"
    static let targetDistance = "targetDistance"
    static let sender = "sender"
}
