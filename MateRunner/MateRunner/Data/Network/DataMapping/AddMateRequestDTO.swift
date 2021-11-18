//
//  AddMateRequestDTO.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import Foundation

struct AddMateRequestDTO: Codable {
    private var notification = FCMNotificationInfo()
    private var data: RequestMate
    private var to: String
    private var priority: String = "high"
    private var contentAvailable: Bool = true
    private var mutableContent: Bool = true
    
    init(data: RequestMate, to: String) {
        self.data = data
        self.to = to
    }
}

struct RequestMate: Codable {
    let host: String

    init(host: String) {
        self.host = host
    }
    
    init?(from dictionary: [AnyHashable: Any]) {
        guard let host = dictionary["host"] as? String else {
                  return nil
              }
        self.init(host: host)
    }
}
