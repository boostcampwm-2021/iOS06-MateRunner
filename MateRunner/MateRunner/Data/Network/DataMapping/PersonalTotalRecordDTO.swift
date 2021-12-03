//
//  PersonalTotalRecordDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct PersonalTotalRecordDTO: Codable {
    private let distance: DoubleValue
    private let time: IntegerValue
    private let calorie: DoubleValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case time, distance, calorie
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.time = try fieldContainer.decode(IntegerValue.self, forKey: .time)
        self.distance = try fieldContainer.decode(DoubleValue.self, forKey: .distance)
        self.calorie = try fieldContainer.decode(DoubleValue.self, forKey: .calorie)
    }
    
    init(totalRecord: PersonalTotalRecord) {
        self.time = IntegerValue(value: String(totalRecord.time))
        self.distance = DoubleValue(value: totalRecord.distance)
        self.calorie = DoubleValue(value: totalRecord.calorie)
    }
    
    func toDomain() -> PersonalTotalRecord {
        return PersonalTotalRecord(
            distance: self.distance.value,
            time: Int(self.time.value) ?? 0,
            calorie: self.calorie.value
        )
    }
}
