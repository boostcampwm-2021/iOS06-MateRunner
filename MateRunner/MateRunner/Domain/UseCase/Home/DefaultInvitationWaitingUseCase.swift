//
//  DefaultInvitationWaitingUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/10.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultInvitationWaitingUseCase: InvitationWaitingUseCase {
    var repository = DefaultInviteMateRepository()
    var runningSetting: RunningSetting
    var requestSuccess: PublishRelay<Bool> = PublishRelay<Bool>()
    var requestStatus: PublishRelay<(Bool, Bool)> = PublishRelay<(Bool, Bool)>()
    var isAccepted: PublishSubject<Bool> = PublishSubject<Bool>()
    var isRejected: PublishSubject<Bool> = PublishSubject<Bool>()
    var isCancelled: PublishSubject<Bool> = PublishSubject<Bool>()
    var invitation: Invitation {
        return Invitation(runningSetting: self.runningSetting, host: User.host.rawValue)
    }
    var disposeBag: DisposeBag = DisposeBag()
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = runningSetting
    }
    
    func inviteMate() {
        // TODO: guard let 구문으로 변경 -> 로그인 및 친구 기능 구현 후 수정 예정입니다
        let mate = self.runningSetting.mateNickname ?? User.mate.rawValue
        
        self.repository.createSession(invitation: self.invitation, mate: mate)
            .subscribe { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.repository.listenSession(invitation: self.invitation)
                        .bind(to: self.requestStatus)
                        .disposed(by: self.disposeBag)
                }
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: self.disposeBag)
        
        self.repository.fetchFCMToken(of: mate)
            .subscribe(onNext: { [weak self] token in
                guard let self = self else { return }
                self.repository.sendInvitation(
                    self.invitation,
                    fcmToken: token
                ).bind(to: self.requestSuccess)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.requestStatus
            .timeout(RxTimeInterval.seconds(60), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .catch({ [weak self] _ in
                guard let self = self else {
                    return PublishRelay<(Bool, Bool)>.just((false, false))
                }
                self.isCancelled.onNext(true)
                self.repository.stopListen(invitation: self.invitation)
                return PublishRelay<(Bool, Bool)>.just((false, false))
            })
                    .debug()
            .subscribe { (isRecieved, isAccepted) in
                if isRecieved {
                    if isAccepted {
                        self.isAccepted.onNext(true)
                    } else {
                        self.isRejected.onNext(true)
                    }
                    self.repository.stopListen(invitation: self.invitation)
                }
            }.disposed(by: disposeBag)
    }
}
