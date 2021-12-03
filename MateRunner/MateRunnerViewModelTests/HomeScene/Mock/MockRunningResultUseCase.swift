//
//  MockRunningResultUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/03.
//

import Foundation

import RxRelay
import RxSwift

final class MockRunningResultUseCase: RunningResultUseCase {
    enum MockError: Error {
        case testError
    }
    var runningResult: RunningResult
    var selectedEmoji = PublishRelay<Emoji>()
    
    init(runningResult: RunningResult) {
        self.runningResult = runningResult
    }
    
    func saveRunningResult() -> Observable<Void> {
        return Observable.error(MockError.testError)
    }
    
    func emojiDidSelect(selectedEmoji: Emoji) {
        self.selectedEmoji.accept(.burningHeart)
    }
}
