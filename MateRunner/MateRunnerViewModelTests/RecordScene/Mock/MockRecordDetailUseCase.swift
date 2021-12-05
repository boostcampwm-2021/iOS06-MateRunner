//
//  MockRecordDetailUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/04.
//

import Foundation

import RxSwift

final class MockRecordDetailUseCase: RecordDetailUseCase {
    var runningResult: RunningResult
    var nickname: String?
    
    init(runningResult: RunningResult) {
        self.runningResult = runningResult
        self.nickname = "mate"
    }
}
