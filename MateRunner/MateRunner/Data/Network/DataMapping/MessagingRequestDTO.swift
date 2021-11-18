//
//  MessagingRequestDTO.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import Foundation

struct FCMNotificationInfo2: Codable {
    private var title: String
    private var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}

struct MessagingRequestDTO<T: Codable>: Codable {
    private var notification: FCMNotificationInfo2
    private var data: T
    private var to: String
    private var priority: String
    private var contentAvailable: Bool
    private var mutableContent: Bool
    
    init(title: String, body: String, data: T, to: String) {
        self.notification = FCMNotificationInfo2(title: title, body: body)
        self.data = data
        self.to = to
        self.priority = "high"
        self.contentAvailable = true
        self.mutableContent = true
    }
}
