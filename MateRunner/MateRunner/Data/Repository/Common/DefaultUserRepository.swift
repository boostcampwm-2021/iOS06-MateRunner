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
        return UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken)
    }
    
    func fetchFCMTokenFromServer(of nickname: String) -> Observable<String> {
        return self.realtimeDatabaseNetworkService.fetchFCMToken(of: nickname)
    }
    
    func deleteFCMToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.fcmToken)
    }
    
    func saveFCMToken(_ fcmToken: String, of nickname: String) -> Observable<Void> {
        return self.realtimeDatabaseNetworkService.update(with: fcmToken, path: ["fcmToken/\(nickname)"])
    }
    
    func fetchUserNickname() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKey.nickname)
    }
    
    func saveLoginInfo(nickname: String) {
        UserDefaults.standard.set(nickname, forKey: UserDefaultKey.nickname)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoggedIn)
    }
    
    func saveLogoutInfo() {
        UserDefaults.standard.set(false, forKey: UserDefaultKey.isLoggedIn)
    }
    
    func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.nickname)
    }
}
