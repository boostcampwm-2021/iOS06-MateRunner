//
//  DefaultUserDefaultPersistence.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import Foundation

final class DefaultUserDefaultPersistence: UserDefaultPersistence {
    func saveLoginInfo(nickname: String) {
        UserDefaults.standard.set(nickname, forKey: "nickname")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
}
