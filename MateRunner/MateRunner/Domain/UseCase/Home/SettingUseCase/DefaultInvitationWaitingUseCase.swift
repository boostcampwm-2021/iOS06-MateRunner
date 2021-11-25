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
    private let inviteMateRepository: InviteMateRepository
    private let userRepository: UserRepository
    private let firestoreRepository = DefaultFirestoreRepository(
        urlSessionService: DefaultURLSessionNetworkService()
    )
    
    var runningSetting: RunningSetting
    var requestSuccess: PublishRelay<Bool> = PublishRelay<Bool>()
    var requestStatus: PublishSubject<(Bool, Bool)> = PublishSubject<(Bool, Bool)>()
    var isAccepted: PublishSubject<Bool> = PublishSubject<Bool>()
    var isRejected: PublishSubject<Bool> = PublishSubject<Bool>()
    var isCancelled: PublishSubject<Bool> = PublishSubject<Bool>()
    var invitation: Invitation {
        return Invitation(runningSetting: self.runningSetting, host: self.userRepository.fetchUserNickname() ?? "")
    }
    var disposeBag: DisposeBag = DisposeBag()
    
    init(runningSetting: RunningSetting, inviteMateRepository: InviteMateRepository, userRepository: UserRepository) {
        self.runningSetting = runningSetting
        self.inviteMateRepository = inviteMateRepository
        self.userRepository = userRepository
    }
    
    func inviteMate() {
        guard let mate = self.runningSetting.mateNickname else { return }
        
        self.saveInvitationNotice(to: mate)
        
        self.inviteMateRepository.createSession(invitation: self.invitation, mate: mate)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.inviteMateRepository.listenInvitationResponse(of: self.invitation)
                    .bind(to: self.requestStatus)
                    .disposed(by: self.disposeBag)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: self.disposeBag)
        
        self.inviteMateRepository.fetchFCMToken(of: mate)
            .subscribe(onNext: { [weak self] token in
                guard let self = self else { return }
                self.inviteMateRepository.sendInvitation(
                    self.invitation,
                    fcmToken: token
                ).subscribe(onNext: { _ in
                    self.requestSuccess.accept(true)
                })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.requestStatus
            .timeout(RxTimeInterval.seconds(10), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .catch({ [weak self] _ in
                guard let self = self else {
                    return PublishRelay<(Bool, Bool)>.just((false, false))
                }
                self.isCancelled.onNext(true)
                self.inviteMateRepository.cancelSession(invitation: self.invitation)
                    .publish()
                    .connect()
                    .disposed(by: self.disposeBag)
                self.inviteMateRepository.stopListen(invitation: self.invitation)
                return PublishRelay<(Bool, Bool)>.just((false, false))
            })
            .subscribe { [weak self] (isRecieved, isAccepted) in
                guard let self = self else { return }
                if isRecieved && isAccepted {
                    self.isAccepted.onNext(true)
                    self.inviteMateRepository.stopListen(invitation: self.invitation)
                } else if isRecieved && !isAccepted {
                    self.isRejected.onNext(true)
                    self.inviteMateRepository.stopListen(invitation: self.invitation)
                }
            }.disposed(by: disposeBag)
    }
    
    private func saveInvitationNotice(to mate: String) {
        guard let userNickname = self.userRepository.fetchUserNickname() else { return }
        
        let notice = Notice(
            id: nil,
            sender: userNickname,
            receiver: mate,
            mode: .invite,
            isReceived: false
        )
        
        self.firestoreRepository.save(notice: notice, of: mate)
            .publish()
            .connect()
            .disposed(by: self.disposeBag)
    }
}
