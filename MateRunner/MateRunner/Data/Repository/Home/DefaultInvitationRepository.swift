//
//  DefaultInvitationRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/15.
//
import Foundation

import Firebase
import RxRelay
import RxSwift

final class DefaultInvitationRepository: InvitationRepository {
    var databaseReference: DatabaseReference = Database.database().reference()

    func saveInvitationResponse(accept: Bool, invitation: Invitation) -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] observer in
            let sessionId = invitation.sessionId
            
            self?.databaseReference.child("session").child("\(sessionId)").updateChildValues([
                "isAccepted": accept,
                "isReceived": true
            ], withCompletionBlock: { error, _ in
                if error != nil {
                    observer.onError(MockError.unknown)
                    return
                }
                observer.onNext(true)
            })

            return Disposables.create()
        }
    }
}
