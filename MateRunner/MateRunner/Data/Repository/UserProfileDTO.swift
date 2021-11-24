//
//  UserProfileDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct UserProfileFirestoreDTO: Codable {
    let height: DoubleValue
    let weight: DoubleValue
    let image: StringValue
    
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
        self.image = StringValue(value: userProfile.iamge)
        self.height = DoubleValue(value: userProfile.height)
        self.weight = DoubleValue(value: userProfile.weight)
    }
    
    func toDomain() -> UserProfile {
        return UserProfile(
            iamge: self.image.value,
            height: self.height.value,
            weight: self.weight.value
        )
    }
}

struct UserProfile {
    let iamge: String
    let height: Double
    let weight: Double
}
