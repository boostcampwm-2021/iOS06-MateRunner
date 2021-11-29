//
//  DefaultUserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift

final class DefaultUserRepository: UserRepository {
    private let realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService
    
    init(realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService) {
        self.realtimeDatabaseNetworkService = realtimeDatabaseNetworkService
    }
    
    func fetchFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken.rawValue)
    }
    
    func fetchFCMTokenFromServer(of nickname: String) -> Observable<String> {
        return self.realtimeDatabaseNetworkService.fetchFCMToken(of: nickname)
    }
    
    func deleteFCMToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.fcmToken.rawValue)
    }
    
    func saveFCMToken(_ fcmToken: String, of nickname: String) -> Observable<Void> {
        return self.realtimeDatabaseNetworkService.update(with: fcmToken, path: ["fcmToken/\(nickname)"])
    }
    
    func fetchUserNickname() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKey.nickname.rawValue)
    }
    
    func saveLoginInfo(nickname: String) {
        UserDefaults.standard.set(nickname, forKey: UserDefaultKey.nickname.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoggedIn.rawValue)
    }
    
    func saveLogoutInfo() {
        UserDefaults.standard.set(false, forKey: UserDefaultKey.isLoggedIn.rawValue)
    }
    
    func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.isLoggedIn.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.nickname.rawValue)
    }
}
