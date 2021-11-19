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
    private let invitationRepository: InvitationRepository = DefaultInvitationRepository(
        realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
    )
    
    var invitation: Invitation

    init(invitation: Invitation) {
        self.invitation = invitation
    }

    func acceptInvitation() -> Observable<Bool> {
        return self.invitationRepository.saveInvitationResponse(accept: true, invitation: self.invitation)
    }

    func rejectInvitation() -> Observable<Bool> {
        return self.invitationRepository.saveInvitationResponse(accept: false, invitation: self.invitation)
    }
}
