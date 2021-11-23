//
//  EmojisDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct EmojisDTO: Codable {
    private(set) var emojis: MapValue?
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case emojis
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.emojis = try? fieldContainer.decode(MapValue.self, forKey: .emojis)
    }
    
    func toDomain() -> [String: String]{
        return self.emojis?.value.fields.mapValues({ $0.value })
    }
}
