//
//  UserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

protocol UserRepository {
    func fetchUserNickname() -> String?
}
