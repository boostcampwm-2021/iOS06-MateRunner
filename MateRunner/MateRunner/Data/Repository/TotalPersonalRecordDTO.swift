//
//  TotalPersonalRecordDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct TotalPresonalRecord {
    let distance: Double
    let time: Int
    let calorie: Double
}

struct TotalPresonalRecordDTO: Codable {
    let distance: DoubleValue
    let time: IntegerValue
    let calorie: DoubleValue
    
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
    
    init(totalRecord: TotalPresonalRecord) {
        self.time = IntegerValue(value: String(totalRecord.time))
        self.distance = DoubleValue(value: totalRecord.distance)
        self.calorie = DoubleValue(value: totalRecord.calorie)
    }
    
    func toDomain() -> TotalPresonalRecord {
        return TotalPresonalRecord(
            distance: self.distance.value,
            time: Int(self.time.value) ?? 0,
            calorie: self.calorie.value
        )
    }
}
