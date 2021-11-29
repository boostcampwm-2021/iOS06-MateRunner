//
//  DefaultUserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift

final class DefaultUserRepository: UserRepository {
    private let networkService: FireStoreNetworkService
    private let realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService
    
    init(
        networkService: FireStoreNetworkService,
        realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService
    ) {
        self.networkService = networkService
        self.realtimeDatabaseNetworkService = realtimeDatabaseNetworkService
    }
    
    func fetchUserNickname() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKey.nickname.rawValue)
    }
    
    func fetchUserNicknameFromServer(uid: String) -> Observable<String> {
        return self.networkService.fetchData(
            type: String.self,
            collection: FirebaseCollection.uid,
            document: uid, field: "nickname"
        )
    }
    
    func fetchFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken.rawValue)
    }
    
    func deleteFCMToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.fcmToken.rawValue)
    }
    
    func saveFCMToken(_ fcmToken: String, of nickname: String) -> Observable<Void> {
        return self.realtimeDatabaseNetworkService.update(with: fcmToken, path: ["fcmToken/\(nickname)"])
    }
    
    func checkRegistration(uid: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: FirebaseCollection.uid, document: uid)
    }
    
    func checkDuplicate(of nickname: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: FirebaseCollection.user, document: nickname)
    }
    
    func saveUserInfo(uid: String, nickname: String, height: Double, weight: Double) -> Observable<Bool> {
        let data: [String: Any] = [
            "nickname": nickname,
            "height": height,
            "weight": weight,
            "time": 0,
            "distance": 0.0,
            "calorie": 0.0,
            "mate": [],
            "image": ""
        ]
        
        let uidResult = self.networkService.writeData(
            collection: FirebaseCollection.uid,
            document: uid,
            data: ["nickname": nickname]
        )
        
        let userResult = self.networkService.writeData(
            collection: FirebaseCollection.user,
            document: nickname,
            data: data
        )
        
        return Observable.zip(uidResult, userResult) { $0 && $1 }
    }
    
    func saveLoginInfo(nickname: String) {
        UserDefaults.standard.set(nickname, forKey: UserDefaultKey.nickname.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoggedIn.rawValue)
    }
    
    func fetchUserInfo(_ nickname: String) -> Observable<UserProfileDTO> {
        return self.networkService.readDTO(
            UserProfileDTO(),
            collection: FirebaseCollection.user,
            document: "hunihun956"
        )
    }

    func fetchRecordList(_ nickname: String) -> Observable<UserResultDTO> {
        return self.networkService.readDTO(
            UserResultDTO(records: [:]),
            collection: FirebaseCollection.runningResult,
            document: "yjtest" // TODO: 이름 바꿔야함
        )
    }
}
