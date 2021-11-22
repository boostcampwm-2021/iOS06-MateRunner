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
//        return self.fireStoreNetworkService.fetchProfile(collection: FirebaseCollection.user, document: nickname)
        return self.fireStoreNetworkService.readDTO(
            UserProfileDTO(
                nickname: "",
                image: "",
                time: 0,
                distance: 0.0,
                calorie: 0.0
            ),
            collection: FirebaseCollection.user,
            document: nickname
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
