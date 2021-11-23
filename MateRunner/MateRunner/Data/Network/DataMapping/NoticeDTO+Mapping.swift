//
//  NoticeDTO+Mapping.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/23.
//

import Foundation

enum NoticeMode: String {
    case invite = "invite"
    case requestMate = "requestMate"
    
    func text() -> String {
        return self.rawValue
    }
}

struct NoticeDTO: Codable {
    private let sender: String
    private let receiver: String
    private let mode: String
    
    init(from domain: Notice) {
        self.sender = domain.sender
        self.receiver = domain.receiver
        
        if domain.mode == .invite {
            self.mode = NoticeMode.invite.text()
        } else {
            self.mode = NoticeMode.requestMate.text()
        }
    }
    
    func toDomain() -> Notice {
        var noticeMode = NoticeMode.invite
        
        if self.mode == NoticeMode.invite.text() {
            noticeMode = NoticeMode.invite
        } else {
            noticeMode = NoticeMode.requestMate
        }
        
        return Notice(
            sender: self.sender,
            receiver: self.receiver,
            mode: noticeMode
        )
    }
}

struct Notice {
    private(set) var sender: String
    private(set) var receiver: String
    private(set) var mode: NoticeMode
    
    init(
        sender: String,
        receiver: String,
        mode: NoticeMode
    ) {
        self.sender = sender
        self.receiver = receiver
        self.mode = mode
    }
}
