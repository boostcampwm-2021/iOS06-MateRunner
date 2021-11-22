//
//  UserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift

protocol UserRepository {
    func fetchUserNickname() -> String?
    func fetchUserInfo(_ nickname: String) -> Observable<UserProfileDTO>
    func fetchRecordList(_ nickname: String) -> Observable<UserResultDTO>
}
