//
//  DefaultUserRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift

final class DefaultUserRepository: UserRepository {
    private let userDefaultPersistence: UserDefaultPersistence
    private let fireStoreNetworkService: FireStoreNetworkService
    
    init(
        userDefaultPersistence: UserDefaultPersistence,
        fireStoreNetworkService: FireStoreNetworkService
    ) {
        self.userDefaultPersistence = userDefaultPersistence
        self.fireStoreNetworkService = fireStoreNetworkService
    }
    
    func fetchUserNickname() -> String? {
        return self.userDefaultPersistence.getStringValue(key: .nickname)
    }
    
    func fetchUserInfo(_ nickname: String) -> Observable<UserProfileDTO> {
        return self.fireStoreNetworkService.readDTO(
            UserProfileDTO(),
            collection: FirebaseCollection.user,
            document: "hunihun956" // TODO: 이름 바꿔야함
        )
    }

    func fetchRecordList(_ nickname: String) -> Observable<UserResultDTO> {
        return self.fireStoreNetworkService.readDTO(
            UserResultDTO(records: [:]),
            collection: FirebaseCollection.runningResult,
            document: "yjtest" // TODO: 이름 바꿔야함
        )
    }
}
