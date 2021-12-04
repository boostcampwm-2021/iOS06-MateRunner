//
//  MockInvitationWaitingUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 김민지 on 2021/12/03.
//

import Foundation

import RxRelay
import RxSwift

final class MockInvitationWaitingUseCase: InvitationWaitingUseCase {
    var runningSetting: RunningSetting
    var requestSuccess: PublishRelay<Bool> = PublishRelay<Bool>()
    var requestStatus: PublishSubject<(Bool, Bool)> = PublishSubject<(Bool, Bool)>()
    var isAccepted: PublishSubject<Bool> = PublishSubject<Bool>()
    var isRejected: PublishSubject<Bool> = PublishSubject<Bool>()
    var isCanceled: PublishSubject<Bool> = PublishSubject<Bool>()
    
    init(runningSetting: RunningSetting) {
        self.runningSetting = runningSetting
    }
    
    func inviteMate() {
        switch self.runningSetting.sessionId {
        case "accepted-session":
            self.requestStatus.onNext((true, true))
            self.requestSuccess.accept(true)
            self.isAccepted.onNext(true)
        case "rejected-session":
            self.requestStatus.onNext((true, false))
            self.requestSuccess.accept(true)
            self.isRejected.onNext(true)
        case "canceled-session":
            self.requestStatus.onNext((false, false))
            self.requestSuccess.accept(true)
            self.isCanceled.onNext(true)
        default:
            break
        }
        
    }
}
