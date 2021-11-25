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
    private let firestoreRepository: FirestoreRepository
    
    init(firestoreRepository: FirestoreRepository, runningResult: RunningResult) {
        self.firestoreRepository = firestoreRepository
        self.runningResult = runningResult
        self.selectedEmoji = PublishRelay<Emoji>()
        self.disposeBag = DisposeBag()
    }
    
    func saveRunningResult() -> Observable<Void> {
        return self.firestoreRepository.save(runningResult: self.runningResult, to: self.runningResult.resultOwner)
            .timeout(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .retry(3)
    }
}

extension DefaultRunningResultUseCase {
    func emojiDidSelect(selectedEmoji: Emoji) {
        guard let mateNickname = self.runningResult.runningSetting.mateNickname else { return }
        
        self.firestoreRepository.save(
            emoji: selectedEmoji,
            to: mateNickname,
            of: self.runningResult.runningID,
            from: self.runningResult.resultOwner
        )
            .subscribe(onNext: { [weak self] _ in
                self?.selectedEmoji.accept(selectedEmoji)
            })
            .disposed(by: self.disposeBag)
    }
}
