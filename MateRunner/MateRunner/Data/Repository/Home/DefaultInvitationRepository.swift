//
//  DefaultInvitationRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/15.
//
import Foundation

import RxSwift

final class DefaultInvitationRepository: InvitationRepository {
    private let realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService
    
    init(realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService) {
        self.realtimeDatabaseNetworkService = realtimeDatabaseNetworkService
    }
    
    func saveInvitationResponse(accept: Bool, invitation: Invitation) -> Observable<Void> {
        let sessionId = invitation.sessionId
        
        return self.realtimeDatabaseNetworkService.updateChildValues(
            with: [
                "isAccepted": accept,
                "isReceived": true
            ],
            path: ["session", "\(sessionId)"]
        )
    }
}
