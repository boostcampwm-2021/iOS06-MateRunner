//
//  DefaultInvitationUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/15.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultInvitationUseCase: InvitationUseCase {
    var invitation: Invitation
    var isCancelled: PublishSubject<Bool> = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    private let invitationRepository: InvitationRepository

    init(invitation: Invitation, invitationRepository: InvitationRepository) {
        self.invitation = invitation
        self.invitationRepository = invitationRepository
    }
    
    func checkIsCancelled() -> Observable<Bool> {
        self.invitationRepository.fetchCancellationStatus(of: self.invitation)
            .subscribe(self.isCancelled)
            .disposed(by: self.disposeBag)
        
        return self.invitationRepository.fetchCancellationStatus(of: self.invitation)
    }

    func acceptInvitation() -> Observable<Void> {
        return self.invitationRepository.saveInvitationResponse(accept: true, invitation: self.invitation)
    }

    func rejectInvitation() -> Observable<Void> {
        return self.invitationRepository.saveInvitationResponse(accept: false, invitation: self.invitation)
    }
}
