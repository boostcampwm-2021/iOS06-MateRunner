//
//  DefaultRunningResultRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import RxSwift

final class DefaultRunningResultRepository: RunningResultRepository {
    let networkService = FireStoreNetworkService()
    
    func saveRunningResult(_ runningResult: RunningResult?) -> Observable<Bool> {
        guard let runningResult = runningResult else { return Observable.of(false) }
        
        let dto = RunningResultDTO(from: runningResult)
        
        return self.networkService.updateArray(
            append: dto,
            collection: "User",
            document: "hunihun956",
            array: "records"
        )
    }
}
