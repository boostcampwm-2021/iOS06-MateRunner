//
//  MessagingRequestDTO.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import Foundation

struct FCMNotificationInfo: Codable {
    private var title: String
    private var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}

struct MessagingRequestDTO<T: Codable>: Codable {
    private var notification: FCMNotificationInfo
    private var data: T
    private var toNickname: String
    private var priority: String
    private var contentAvailable: Bool
    private var mutableContent: Bool
    
    init(title: String, body: String, data: T, to nickname: String) {
        self.notification = FCMNotificationInfo(title: title, body: body)
        self.data = data
        self.toNickname = nickname
        self.priority = "high"
        self.contentAvailable = true
        self.mutableContent = true
    }
}
