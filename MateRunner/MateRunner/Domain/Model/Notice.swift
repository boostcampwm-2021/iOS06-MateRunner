//
//  Notice.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/24.
//

import Foundation

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
