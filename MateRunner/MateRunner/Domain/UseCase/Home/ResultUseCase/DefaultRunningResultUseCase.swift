//
//  DefaultRunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultRunningResultUseCase: RunningResultUseCase {
    var runningResult: RunningResult
    var selectedEmoji: PublishRelay<Emoji>
    private let disposeBag: DisposeBag
    
    private let runningResultRepository: RunningResultRepository
    
    init(runningResultRepository: RunningResultRepository, runningResult: RunningResult) {
        self.runningResultRepository = runningResultRepository
        self.runningResult = runningResult
        self.selectedEmoji = PublishRelay<Emoji>()
        self.disposeBag = DisposeBag()
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

extension DefaultRunningResultUseCase {
    func emojiDidSelect(selectedEmoji: Emoji) {
        guard let mateNickname = self.runningResult.runningSetting.mateNickname else { return }
        
        self.runningResultRepository.sendEmoji(
            selectedEmoji,
            to: mateNickname,
            with: self.runningResult.runningID
        )
            .subscribe(onNext: { [weak self] _ in
                self?.selectedEmoji.accept(selectedEmoji)
            })
            .disposed(by: self.disposeBag)
    }
}
