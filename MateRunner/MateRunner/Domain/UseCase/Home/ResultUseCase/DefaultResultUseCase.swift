//
//  DefaultRunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import Foundation

import RxSwift

final class DefaultRunningResultUseCase: RunningResultUseCase {
    var runningResult: RunningResult
    private let runningResultRepository: RunningResultRepository
    
    init(runningResultRepository: RunningResultRepository, runningResult: RunningResult) {
        self.runningResultRepository = runningResultRepository
        self.runningResult = runningResult
    }
    
    func saveRunningResult() -> Observable<Void> {
        return self.runningResultRepository.saveRunningResult(runningResult)
            .timeout(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .retry(3)
    }
 }
