//
//  UserDefaultPersistence.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import Foundation

protocol UserDefaultPersistence {
    func saveLoginInfo(nickname: String)
}
