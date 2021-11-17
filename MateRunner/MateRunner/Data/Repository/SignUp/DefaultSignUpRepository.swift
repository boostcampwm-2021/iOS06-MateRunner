//
//  DefaultSignUpRepository.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/16.
//

import Foundation

import RxSwift

final class DefaultSignUpRepository: SignUpRepository {
    private let networkService: FireStoreNetworkService
    private let userDefaultPersistence: UserDefaultPersistence
    
    init(networkService: FireStoreNetworkService, userDefaultPersistence: UserDefaultPersistence) {
        self.networkService = networkService
        self.userDefaultPersistence = userDefaultPersistence
    }
    
    func checkDuplicate(of nickname: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: "User", document: nickname)
    }
    
    func saveUserInfo(nickname: String, height: Int, weight: Int) -> Observable<Bool> {
        let data: [String: Any] = [
            "height": height,
            "weight": weight
        ]
        return self.networkService.writeData(collection: "User", document: nickname, data: data)
    }
    
    func saveLoginInfo(nickname: String) {
        self.userDefaultPersistence.setValue(nickname, key: .nickname)
        self.userDefaultPersistence.setValue(true, key: .isLoggedIn)
    }
}
