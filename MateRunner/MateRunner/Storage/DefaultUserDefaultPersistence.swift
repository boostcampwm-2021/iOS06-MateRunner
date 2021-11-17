//
//  DefaultUserDefaultPersistence.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import Foundation

final class DefaultUserDefaultPersistence: UserDefaultPersistence {
    func setValue(_ value: Any?, key: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: "\(key)")
    }
    
    func getStringValue(key: UserDefaultKey) -> String? {
        return UserDefaults.standard.string(forKey: "\(key)")
    }
    
    func getBooleanValue(key: UserDefaultKey) -> Bool {
        return UserDefaults.standard.bool(forKey: "\(key)")
    }
}
