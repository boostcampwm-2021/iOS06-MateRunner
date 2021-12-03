//
//  DefaultProfileUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/21.
//

import Foundation

import RxSwift

final class DefaultProfileUseCase: ProfileUseCase {
    private let firestoreRepository: FirestoreRepository
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    private let selfNickname: String?
    var userInfo: PublishSubject<UserData> = PublishSubject()
    var recordInfo: PublishSubject<[RunningResult]> = PublishSubject()
    var selectEmoji: PublishSubject<Emoji> = PublishSubject()
    
    init(
        userRepository: UserRepository,
        firestoreRepository: FirestoreRepository
    ) {
        self.userRepository = userRepository
        self.firestoreRepository = firestoreRepository
        self.selfNickname = self.userRepository.fetchUserNickname()
    }
    
    func fetchUserInfo(_ nickname: String) {
        self.firestoreRepository.fetchUserData(of: nickname)
            .subscribe(onNext: { [weak self] mate in
                self?.userInfo.onNext(mate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchRecordList(nickname: String, from index: Int, by count: Int) {
        self.firestoreRepository.fetchResult(of: nickname, from: index, by: count)
            .catchAndReturn([])
            .subscribe(onNext: { [weak self] records in
                guard let self = self else { return }
                if records.count == 0 {
                    self.recordInfo.onNext([])
                    return
                }
                Observable<RunningResult>.zip( records.map { [weak self] record -> Observable<RunningResult> in
                    return self?.fetchRecordEmoji(record, from: nickname) ?? Observable.of(record)
                })
                    .subscribe(onNext: { [weak self] list in
                        guard let self = self else { return }
                        self.recordInfo.onNext(self.sortByDate(results: list))
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchRecordEmoji(_ record: RunningResult, from nickname: String) -> Observable<RunningResult> {
        return self.firestoreRepository.fetchEmojis(of: record.runningID, from: nickname)
            .catchAndReturn([:])
            .map({ emoji -> RunningResult in
                let result = record
                result.updateEmoji(to: emoji)
                return result
            })
    }
    
    func fetchUserNickname() -> String? {
        self.userRepository.fetchUserNickname()
    }
    
    func emojiDidSelect(selectedEmoji: Emoji) {
        self.selectEmoji.onNext(selectedEmoji)
    }
    
    func deleteEmoji(from runningID: String, of mate: String) -> Observable<Void> {
        guard let selfNickname = self.selfNickname else { return Observable.just(()) }
        return self.firestoreRepository.removeEmoji(
            from: runningID,
            of: mate,
            with: selfNickname
        )
    }
    
    private func sortByDate(results: [RunningResult]) -> [RunningResult] {
        return results.sorted { $0.dateTime ?? Date() > $1.dateTime ?? Date() }
    }
}
