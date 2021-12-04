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
    
    init() {
        self.runningResult = RaceRunningResult(
            userNickname: "mate",
            runningSetting: RunningSetting(
                sessionId: "session-id",
                mode: .race,
                targetDistance: 5.0,
                hostNickname: "mate",
                mateNickname: "runner",
                dateTime: Date()
            ),
            userElapsedDistance: 5.0,
            userElapsedTime: 10,
            calorie: 15.0,
            points: [],
            emojis: [:],
            isCanceled: false,
            mateElapsedDistance: 2.0,
            mateElapsedTime: 5
        )
        self.nickname = "mate"
    }
}
