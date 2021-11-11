//
//  RunningSetting.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/03.
//

import Foundation

struct RunningSetting {
    var mode: RunningMode?
    var targetDistance: Double?
    // TODO: user ID 받아와서 설정
    var hostNickname: String = User.host.rawValue
    var mateNickname: String?
    var dateTime: Date?
}
