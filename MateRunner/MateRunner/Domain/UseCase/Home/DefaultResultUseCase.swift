//
//  DefaultRunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import Foundation

import RxSwift
import Firebase
import FirebaseFirestore

final class DefaultRunningResultUseCase: RunningResultUseCase {
    let runningResultRepository: RunningResultRepository = DefaultRunningResultRepository()
    
    func saveRunningResult(_ runningResult: RunningResult?) -> Observable<Bool> {
        return self.runningResultRepository.saveRunningResult(runningResult)
    }
 }
