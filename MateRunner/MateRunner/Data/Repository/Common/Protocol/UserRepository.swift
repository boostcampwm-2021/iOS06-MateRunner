//
//  UserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift

protocol UserRepository {
    func fetchFCMToken() -> String?
    func fetchFCMTokenFromServer(of nickname: String) -> Observable<String>
    func deleteFCMToken()
    func saveFCMToken(_ fcmToken: String, of nickname: String) -> Observable<Void>
    func fetchUserNickname() -> String?
    func saveLoginInfo(nickname: String)
    func saveLogoutInfo()
    func deleteUserInfo()
}
