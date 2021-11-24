//
//  MatesDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct MatesDTO: Decodable {
    let mate: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case mate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.mate = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .mate)
    }
    
    init(mates: [String]) {
        self.mate = ArrayValue(values: mates.map({ StringValue(value: $0) }))
    }
    
    func toDomain() -> [String] {
        return self.mate.arrayValue["values"]?.compactMap({ $0.value }) ?? []
    }
}
