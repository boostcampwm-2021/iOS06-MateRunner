//
//  NoticeDTO+Mapping.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/23.
//

import Foundation

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
        return Notice(
            sender: self.sender,
            receiver: self.receiver,
            mode: NoticeMode(rawValue: self.mode) ?? .invite
        )
    }
}
