//
//  FirestoreValues.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation

struct StringValue: Codable {
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "stringValue"
    }
}

struct IntegerValue: Codable {
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "integerValue"
    }
}

struct BooleanValue: Codable {
    let value: Bool
    
    private enum CodingKeys: String, CodingKey {
        case value = "booleanValue"
    }
}

struct GeoPointValue: Codable {
    let value: Point
    
    private enum CodingKeys: String, CodingKey {
        case value = "geoPointValue"
    }
}

struct DoubleValue: Codable {
    let value: Double
    
    private enum CodingKeys: String, CodingKey {
        case value = "doubleValue"
    }
}

struct TimeStampValue: Codable {
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "timestampValue"
    }
}

struct ArrayValue<T: Codable>: Codable {
    let values: [T]
    
    private enum FieldKeys: String, CodingKey {
        case arrayValue
    }
    
    private enum CodingKeys: String, CodingKey {
        case values
    }
    
    init(values: [T]) {
        self.values = values
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FieldKeys.self)
        let fieldContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .arrayValue)
        self.values = try fieldContainer.decode([T].self, forKey: .values)
    }
}

struct MapValue: Codable {
    let value: FieldValue
    
    private enum CodingKeys: String, CodingKey {
        case value = "mapValue"
    }
    
    init(value: FieldValue) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(FieldValue.self, forKey: .value)
    }
}

struct FieldValue: Codable {
    var value: [String: StringValue]
    
    private enum CodingKeys: String, CodingKey {
        case value = "fields"
    }
    
    init(field: [String: StringValue]) {
        self.value = field
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode([String: StringValue].self, forKey: .value)
    }
}
