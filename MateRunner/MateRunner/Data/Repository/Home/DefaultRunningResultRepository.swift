//
//  DefaultRunningResultRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import RxSwift

final class DefaultRunningResultRepository: RunningResultRepository {
    let fireStoreService: FireStoreNetworkService
    let userDefaultPersistence: UserDefaultPersistence
    
    init(fireStoreService: FireStoreNetworkService, userDefaultsPersistence: UserDefaultPersistence) {
        self.fireStoreService = fireStoreService
        self.userDefaultPersistence = userDefaultsPersistence
    }
    
    private func fetchUserNickname() -> String? {
        return self.userDefaultPersistence.getStringValue(key: .nickname)
    }
    
    func saveRunningResult(_ runningResult: RunningResult?) -> Observable<Void> {
        guard let runningResult = runningResult,
              let startDateTime = runningResult.dateTime else {
            return Observable.error(FirebaseServiceError.nilDataError)
        }

        guard let userNickName = self.fetchUserNickname() else {
            return Observable.error(FirebaseServiceError.userNicknameNotExistsError)
        }
        
        return self.fireStoreService.writeDTO(
            RunningResultDTO(from: runningResult),
            collection: FirebaseCollection.runningResult,
            document: userNickName,
            key: startDateTime.fullDateTimeString()
        )
    }
}
