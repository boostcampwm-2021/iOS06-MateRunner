//
//  DefaultRunningResultRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import RxSwift

enum FirebaseServiceError: Error {
    case nilDataError
}

final class DefaultRunningResultRepository: RunningResultRepository {
    let networkService = DefaultFireStoreNetworkService()
    
    func saveRunningResult(_ runningResult: RunningResult?) -> Observable<Void> {
        guard let runningResult = runningResult else {
            return Observable.error(FirebaseServiceError.nilDataError)
        }
        
        return self.networkService.writeDTO(
            RunningResultDTO(from: runningResult),
            collection: "RunningResult",
            document: "hunihun956",
            key: runningResult.dateTime?.fullDateTimeString() ?? Date().fullDateTimeString()
        )
    }
}
