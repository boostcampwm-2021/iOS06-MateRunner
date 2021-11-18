//
//  DefaultUserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

final class DefaultUserRepository: UserRepository {
    private let userDefaultPersistence: UserDefaultPersistence
    
    init(userDefaultPersistence: UserDefaultPersistence) {
        self.userDefaultPersistence = userDefaultPersistence
    }
    
    func fetchUserNickname() -> String? {
        return self.userDefaultPersistence.getStringValue(key: .nickname)
    }
}
