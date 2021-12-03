//
//  UserFirestoreDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct UserDataFirestoreDTO: Codable {
    private let nickname: StringValue
    private let image: StringValue
    private let time: IntegerValue
    private let distance: DoubleValue
    private let calorie: DoubleValue
    private let height: DoubleValue
    private let weight: DoubleValue
    private let mate: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case nickname, image, time, distance, calorie, height, weight, mate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.nickname = try fieldContainer.decode(StringValue.self, forKey: .nickname)
        self.image = try fieldContainer.decode(StringValue.self, forKey: .image)
        self.time = try fieldContainer.decode(IntegerValue.self, forKey: .time)
        self.distance = try fieldContainer.decode(DoubleValue.self, forKey: .distance)
        self.calorie = try fieldContainer.decode(DoubleValue.self, forKey: .calorie)
        self.height = try fieldContainer.decode(DoubleValue.self, forKey: .height)
        self.weight = try fieldContainer.decode(DoubleValue.self, forKey: .weight)
        self.mate = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .mate)
    }
    
    init(userData: UserData) {
        self.nickname = StringValue(value: userData.nickname)
        self.image = StringValue(value: userData.image)
        self.time = IntegerValue(value: String(userData.time))
        self.distance = DoubleValue(value: userData.distance)
        self.calorie = DoubleValue(value: userData.calorie)
        self.height = DoubleValue(value: userData.height)
        self.weight = DoubleValue(value: userData.weight)
        self.mate = ArrayValue(values: userData.mate.map({ StringValue(value: $0) }))
    }
    
    func toDomain() -> UserData {
        return UserData(
            nickname: self.nickname.value,
            image: self.image.value,
            time: Int(self.time.value) ?? 0,
            distance: self.distance.value,
            calorie: self.calorie.value,
            height: self.height.value,
            weight: self.weight.value,
            mate: self.mate.arrayValue["values"]?.compactMap({ $0.value }) ?? []
        )
    }
}
