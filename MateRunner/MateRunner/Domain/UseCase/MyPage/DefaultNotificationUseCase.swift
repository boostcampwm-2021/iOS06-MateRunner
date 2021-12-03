//
//  DefaultNotificationUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

final class DefaultNotificationUseCase: NotificationUseCase {
    private let userRepository: UserRepository
    private let firestoreRepository: FirestoreRepository
    private let disposeBag = DisposeBag()
    
    var notices: PublishSubject<[Notice]> = PublishSubject()
    
    init(
        userRepository: UserRepository,
        firestoreRepository: FirestoreRepository
    ) {
        self.userRepository = userRepository
        self.firestoreRepository = firestoreRepository
    }
    
    func fetchNotices() {
        guard let userNickname = self.userRepository.fetchUserNickname() else { return }
        
        self.firestoreRepository.fetchNotice(of: userNickname)
            .subscribe(
                onNext: { [weak self] notices in
                    self?.notices.onNext(notices)
                },
                onError: { [weak self] _ in
                    self?.notices.onNext([])
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func updateMateState(notice: Notice, isAccepted: Bool) {
        guard let userNickname = self.userRepository.fetchUserNickname() else { return }
        
        if isAccepted {
            self.acceptMate(notice)
        }
        
        self.updateNoticeState(notice, of: userNickname)
    }
    
    private func acceptMate(_ notice: Notice) {
        self.firestoreRepository.save(mate: notice.receiver, to: notice.sender)
            .publish()
            .connect()
            .disposed(by: self.disposeBag)
        
        self.firestoreRepository.save(mate: notice.sender, to: notice.receiver)
            .publish()
            .connect()
            .disposed(by: self.disposeBag)
    }
    
    private func updateNoticeState(_ notice: Notice, of userNickname: String) {
        self.firestoreRepository.updateState(
            notice: notice.copyUpdatedReceived(),
            of: userNickname
        )
            .subscribe(onNext: { [weak self] in
                self?.fetchNotices()
            })
            .disposed(by: self.disposeBag)
    }
}
