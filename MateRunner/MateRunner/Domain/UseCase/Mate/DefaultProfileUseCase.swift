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
    var userInfo: PublishSubject<UserData> = PublishSubject()
    var recordInfo: PublishSubject<[RunningResult]> = PublishSubject()
    
    init(
        userRepository: UserRepository,
        firestoreRepository: FirestoreRepository
    ) {
        self.userRepository = userRepository
        self.firestoreRepository = firestoreRepository
    }
    
    func fetchUserInfo(_ nickname: String) {
        self.firestoreRepository.fetchUserData(of: nickname)
            .subscribe(onNext: { [weak self] mate in
                self?.userInfo.onNext(mate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchRecordList(nickname: String) {
        var recordList: [RunningResult] = []
        self.firestoreRepository.fetchResult(of: nickname, from: 0, by: 20)
            .subscribe(onNext: { [weak self] records in
                records.forEach { record in
                    self?.firestoreRepository.fetchEmojis(of: record.runningID, from: nickname)
                        .subscribe(onNext: { emoji in
                            recordList.append(
                                RunningResult(
                                    userNickname: nickname,
                                    runningSetting: record.runningSetting,
                                    userElapsedDistance: record.userElapsedDistance,
                                    userElapsedTime: record.userElapsedTime,
                                    calorie: record.calorie,
                                    points: record.points,
                                    emojis: emoji,
                                    isCanceled: record.isCanceled
                                )
                            )
                            self?.recordInfo.onNext(recordList) //TODO: 리팩토링 필요한 부분
                        })
                        .disposed(by: self?.disposeBag ?? DisposeBag())
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchUserNickname() -> String? {
        self.userRepository.fetchUserNickname()
    }
    
}
