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
    
    init(fireStoreService: FireStoreNetworkService) {
        self.fireStoreService = fireStoreService
    }
    
    private func fetchUserNickname() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKey.nickname.rawValue)
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
