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
    func fetchUserNicknameFromServer(uid: String) -> Observable<String>
    func checkRegistration(uid: String) -> Observable<Bool>
    func checkDuplicate(of nickname: String) -> Observable<Bool>
    func saveUserInfo(uid: String, nickname: String, height: Int, weight: Int) -> Observable<Bool>
    func saveLoginInfo(nickname: String)
}
