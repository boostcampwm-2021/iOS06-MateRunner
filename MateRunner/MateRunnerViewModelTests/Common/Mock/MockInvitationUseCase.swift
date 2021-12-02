//
//  MockInvitationUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import Foundation

import RxSwift

final class MockInvitationUseCase: InvitationUseCase {
    var invitation: Invitation
    var isCancelled: PublishSubject<Bool>
    
    init() {
        self.isCancelled = PublishSubject()
        self.invitation = Invitation(
            sessionId: "session-id",
            host: "materunner",
            inviteTime: "2:00",
            mode: .race,
            targetDistance: 5.00,
            mate: "runner"
        )
    }
    
    func checkIsCancelled() -> Observable<Bool> {
        return Observable.just(false)
    }
    
    func acceptInvitation() -> Observable<Void> {
        self.isCancelled.onNext(false)
        return Observable.just(())
    }
    
    func rejectInvitation() -> Observable<Void> {
        self.isCancelled.onNext(true)
        return Observable.just(())
    }
}
