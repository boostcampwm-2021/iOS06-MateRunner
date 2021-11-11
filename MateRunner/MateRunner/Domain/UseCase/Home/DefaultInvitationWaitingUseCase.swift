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
        // TODO: guard let 구문으로 변경
        let mate = self.runningSetting.mateNickname ?? User.mate.rawValue
        
        self.repository.createSession(invitation: self.invitation, mate: mate)
            .debug()
            .subscribe { success in
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
            .debug()
            .subscribe(onNext: { token in
                self.repository.sendInvitation(
                    self.invitation,
                    fcmToken: token
                ).debug().bind(to: self.requestSuccess)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.requestStatus
            .debug()
            .subscribe { (isRecieved, isAccepted) in
                if isRecieved && isAccepted {
                    self.isAccepted.onNext(true)
                } else if isRecieved && !isAccepted {
                    self.isRejected.onNext(true)
                }
                // TODO: 1분 지나고 isReceived == false => 시간 초과 안내
            }.disposed(by: disposeBag)
    }
}
