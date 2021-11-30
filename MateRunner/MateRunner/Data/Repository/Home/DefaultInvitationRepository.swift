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
    
    func fetchCancellationStatus(of invitation: Invitation) -> Observable<Bool> {
        let sessionId = invitation.sessionId
        
        return self.realtimeDatabaseNetworkService.fetch(of: [RealtimeDatabaseKey.session, sessionId])
            .map { data in
                guard let isCancelled = data[RealtimeDatabaseKey.isCancelled] as? Bool else {
                    return false
                }
                return isCancelled
            }
    }
    
    func saveInvitationResponse(accept: Bool, invitation: Invitation) -> Observable<Void> {
        let sessionId = invitation.sessionId
        
        return self.realtimeDatabaseNetworkService.updateChildValues(
            with: [
                RealtimeDatabaseKey.isAccepted: accept,
                RealtimeDatabaseKey.isReceived: true
            ],
            path: [RealtimeDatabaseKey.session, sessionId]
        )
    }
}
