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
    
    init(networkService: FireStoreNetworkService) {
        self.networkService = networkService
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
    
    func checkRegistration(uid: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: FirebaseCollection.uid, document: uid)
    }
    
    func checkDuplicate(of nickname: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: FirebaseCollection.user, document: nickname)
    }
    
    func saveUserInfo(uid: String, nickname: String, height: Int, weight: Int) -> Observable<Bool> {
        let data: [String: Any] = [
            "nickname": nickname,
            "height": height,
            "weight": weight
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
            document: "hunihun956" // TODO: 이름 바꿔야함
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
