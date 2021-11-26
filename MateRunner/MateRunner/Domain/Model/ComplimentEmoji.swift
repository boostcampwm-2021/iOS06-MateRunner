//
//  ComplimentEmoji.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/27.
//

import Foundation

struct ComplimentEmoji: Codable {
    let sender: String

    init(sender: String) {
        self.sender = sender
    }
    
    init?(from dictionary: [AnyHashable: Any]) {
        guard let sender = dictionary["sender"] as? String else {
                  return nil
              }
        self.init(sender: sender)
    }
}
