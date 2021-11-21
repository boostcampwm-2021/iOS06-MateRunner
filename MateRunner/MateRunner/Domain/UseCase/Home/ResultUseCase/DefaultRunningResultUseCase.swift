//
//  DefaultRunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import Foundation

import RxSwift
import RxRelay

protocol EmojiDidSelectDelegate: AnyObject {
    func emojiDidSelect(selectedEmoji: Emoji)
}

final class DefaultRunningResultUseCase: RunningResultUseCase {
    var runningResult: RunningResult
    var selectedEmoji: PublishRelay<Emoji>
    
    private let runningResultRepository: RunningResultRepository
    
    init(runningResultRepository: RunningResultRepository, runningResult: RunningResult) {
        self.runningResultRepository = runningResultRepository
        self.runningResult = runningResult
        self.selectedEmoji = PublishRelay<Emoji>()
    }
    
    func saveRunningResult() -> Observable<Void> {
        return self.runningResultRepository.saveRunningResult(runningResult)
            .timeout(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .retry(3)
    }
    
    func fetchUserNickname() -> String? {
        self.runningResultRepository.fetchUserNickname()
    }
}
