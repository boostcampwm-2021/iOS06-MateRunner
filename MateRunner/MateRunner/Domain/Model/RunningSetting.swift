//
//  RunningSetting.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/03.
//

import Foundation

struct RunningSetting: Equatable {
    var sessionId: String?
    var mode: RunningMode?
    var targetDistance: Double?
    var hostNickname: String?
    var mateNickname: String?
    var dateTime: Date?
}
