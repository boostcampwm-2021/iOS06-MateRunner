//
//  MateRequest.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import Foundation

struct MateRequest: Codable {
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
