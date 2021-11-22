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
    
    func fetchUserInfo(_ nickname: String) -> Observable<UserProfile> {
        return self.fireStoreNetworkService.fetchProfile(collection: FirebaseCollection.user, document: nickname)
    }

    func fetchRecordList(_ nickname: String) {
//        return self.fireStoreService.writeDTO(
//            RunningResultDTO(from: runningResult),
//            collection: FirebaseCollection.runningResult,
//            document: userNickName,
//            key: startDateTime.fullDateTimeString()
//        )
        self.fireStoreNetworkService.readDTO(
            RunningResultDTO(from: RunningResult(runningSetting: RunningSetting())),
            collection: "RunningResult",
            document: "yjtest"
        )
    }
}
