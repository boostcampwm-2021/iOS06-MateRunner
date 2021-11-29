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
    func fetchFCMToken() -> String?
    func deleteFCMToken()
    func saveFCMToken(_ fcmToken: String, of nickname: String) -> Observable<Void>
    func checkRegistration(uid: String) -> Observable<Bool>
    func checkDuplicate(of nickname: String) -> Observable<Bool>
    func saveUserInfo(uid: String, nickname: String, height: Double, weight: Double) -> Observable<Bool>
    func saveLoginInfo(nickname: String)
    func saveLogoutInfo()
    func fetchUserInfo(_ nickname: String) -> Observable<UserProfileDTO>
    func fetchRecordList(_ nickname: String) -> Observable<UserResultDTO>
}
