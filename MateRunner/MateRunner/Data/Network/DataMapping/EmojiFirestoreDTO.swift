//
//  EmojiFirestoreDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct EmojiFirestoreDTO: Codable {
    private(set) var emoji: StringValue
    private(set) var userNickname: StringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case emoji, userNickname
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.emoji = try fieldContainer.decode(StringValue.self, forKey: .emoji)
        self.userNickname = try fieldContainer.decode(StringValue.self, forKey: .userNickname)
    }
    
    init(emoji: String, userNickname: String) {
        self.emoji = StringValue(value: emoji)
        self.userNickname = StringValue(value: userNickname)
    }
    
    func toDomain() -> [String: String] {
        return [userNickname.value: emoji.value]
    }
}
