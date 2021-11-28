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
    
    func fetchRecordList(nickname: String) {
        self.firestoreRepository.fetchResult(of: nickname, from: 0, by: 20)
            .subscribe(onNext: { [weak self] records in
                Observable<RunningResult>.zip( records.map { [weak self] record in
                    self?.fetchRecordEmoji(record, from: nickname) ?? Observable.of(record)
                })
                    .subscribe { [weak self] list in
                        self?.recordInfo.onNext(list)
                    }
                    .disposed(by: self?.disposeBag ?? DisposeBag())
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
    
    func deleteEmoji(from runningID: String, of mate: String) {
        guard let selfNickname = self.selfNickname else { return }
        self.firestoreRepository.removeEmoji(from: runningID, of: mate, with: selfNickname)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
