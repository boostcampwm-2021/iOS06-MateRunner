//
//  DefaultUserDefaultPersistence.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import Foundation

final class DefaultUserDefaultPersistence: UserDefaultPersistence {
    func setValue(_ value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
