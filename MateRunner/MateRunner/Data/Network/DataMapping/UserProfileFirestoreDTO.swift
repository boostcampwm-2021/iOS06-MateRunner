//
//  UserProfileFirestoreDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct UserProfileFirestoreDTO: Codable {
    private let height: DoubleValue
    private let weight: DoubleValue
    private let image: StringValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case height, weight, image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.height = try fieldContainer.decode(DoubleValue.self, forKey: .height)
        self.weight = try fieldContainer.decode(DoubleValue.self, forKey: .weight)
        self.image = try fieldContainer.decode(StringValue.self, forKey: .image)
    }
    
    init(userProfile: UserProfile) {
        self.image = StringValue(value: userProfile.image)
        self.height = DoubleValue(value: userProfile.height)
        self.weight = DoubleValue(value: userProfile.weight)
    }
    
    func toDomain() -> UserProfile {
        return UserProfile(
            image: self.image.value,
            height: self.height.value,
            weight: self.weight.value
        )
    }
}
