//
//  DefaultUserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift
import UIKit

final class DefaultUserRepository: UserRepository {
    private let networkService: FireStoreNetworkService
    
    init(networkService: FireStoreNetworkService) {
        self.networkService = networkService
    }
    
    func fetchUserNickname() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKey.nickname.rawValue)
    }
    
    func fetchUserNicknameFromServer(uid: String) -> Observable<String> {
        return self.networkService.fetchData(type: String.self, collection: "UID", document: uid, field: "nickname")
    }
    
    func checkRegistration(uid: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: "UID", document: uid)
    }
    
    func checkDuplicate(of nickname: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: "User", document: nickname)
    }
    
    func saveUserInfo(uid: String, nickname: String, height: Int, weight: Int) -> Observable<Bool> {
        let data: [String: Any] = [
            "nickname": nickname,
            "height": height,
            "weight": weight
        ]
        let uidResult = self.networkService.writeData(collection: "UID", document: uid, data: ["nickname": nickname])
        let userResult = self.networkService.writeData(collection: "User", document: nickname, data: data)
        return Observable.zip(uidResult, userResult) { $0 && $1 }
    }
    
    func saveLoginInfo(nickname: String) {
        UserDefaults.standard.set(nickname, forKey: UserDefaultKey.nickname.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoggedIn.rawValue)
    }
}
