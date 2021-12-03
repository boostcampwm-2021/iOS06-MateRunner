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
        self.fetchCurrentTotalRecord()
            .flatMap({ currentRecord -> Observable<Void> in
                let newRecord = currentRecord.createCumulativeRecord(
                    distance: self.runningResult.userElapsedDistance,
                    time: self.runningResult.userElapsedTime,
                    calorie: self.runningResult.calorie
                )
                return self.firestoreRepository.saveAll(
                    runningResult: self.runningResult,
                    personalTotalRecord: newRecord,
                    userNickname: self.runningResult.resultOwner
                )
            })
    }
    
    private func fetchCurrentTotalRecord() -> Observable<PersonalTotalRecord> {
        return Observable.create({ emitter in
            self.firestoreRepository.fetchTotalPeronsalRecord(of: self.runningResult.resultOwner)
                .subscribe(onNext: { userRecord in
                    emitter.onNext(userRecord)
                }, onError: { error in
                    emitter.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
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
