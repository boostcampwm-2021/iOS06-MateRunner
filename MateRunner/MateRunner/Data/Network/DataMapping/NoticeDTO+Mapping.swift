//
//  NoticeDTO+Mapping.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/23.
//

import Foundation

struct NoticeDTO: Codable {
    private let id: String?
    private let sender: StringValue
    private let receiver: StringValue
    private let mode: StringValue
    private let isReceived: BooleanValue
    
    private enum RootKey: String, CodingKey {
        case id = "name", fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case sender, receiver, mode, isReceived
    }
    
    init(from domain: Notice) {
        self.id = nil
        self.sender = StringValue(value: domain.sender)
        self.receiver = StringValue(value: domain.receiver)
        self.isReceived = BooleanValue(value: domain.isReceived)
        
        if domain.mode == .invite {
            self.mode = StringValue(value: NoticeMode.invite.text())
        } else {
            self.mode = StringValue(value: NoticeMode.requestMate.text())
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.sender = try fieldContainer.decode(StringValue.self, forKey: .sender)
        self.receiver = try fieldContainer.decode(StringValue.self, forKey: .receiver)
        self.isReceived = try fieldContainer.decode(BooleanValue.self, forKey: .isReceived)
        self.mode = try fieldContainer.decode(StringValue.self, forKey: .mode)
    }
    
    func toDomain() -> Notice {
        return Notice(
            id: self.id,
            sender: self.sender.value,
            receiver: self.receiver.value,
            mode: NoticeMode(rawValue: self.mode.value) ?? .invite,
            isReceived: self.isReceived.value
        )
    }
}
