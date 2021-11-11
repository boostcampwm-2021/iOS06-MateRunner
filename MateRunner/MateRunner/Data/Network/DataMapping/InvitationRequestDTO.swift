//
//  InvitationRequestDTO.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/11.
//

import Foundation

struct FCMNotificationInfo: Codable {
    private var title: String = "함께 달리기 초대"
    private var body: String = "메이트의 초대가 도착했습니다!"
}

struct InvitationRequestDTO: Codable {
    private var notification = FCMNotificationInfo()
    private var data: Invitation
    private var to: String
    private var priority: String = "high"
    private var contentAvailable: Bool = true
    private var mutableContent: Bool = true
    
    init(data: Invitation, to: String) {
        self.data = data
        self.to = to
    }
}
