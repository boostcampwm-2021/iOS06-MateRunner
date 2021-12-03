//
//  Notice.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/24.
//

import Foundation

struct Notice: Equatable {
    private(set) var id: String?
    private(set) var sender: String
    private(set) var receiver: String
    private(set) var mode: NoticeMode
    private(set) var isReceived: Bool
    
    init(
        id: String?,
        sender: String,
        receiver: String,
        mode: NoticeMode,
        isReceived: Bool
    ) {
        self.id = id
        self.sender = sender
        self.receiver = receiver
        self.mode = mode
        self.isReceived = isReceived
    }
    
    func copyUpdatedReceived() -> Notice {
        return .init(
            id: self.id,
            sender: self.sender,
            receiver: self.receiver,
            mode: self.mode,
            isReceived: true
        )
    }
}
