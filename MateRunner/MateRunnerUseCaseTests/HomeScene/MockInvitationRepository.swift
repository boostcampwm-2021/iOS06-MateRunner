//
//  MockInvitationRepository.swift
//  MateRunnerUseCaseTests
//
//  Created by 김민지 on 2021/11/30.
//

@testable import MateRunner
import Foundation

import RxSwift

final class MockInvitationRepository: InvitationRepository {
    func fetchCancellationStatus(of invitation: Invitation) -> Observable<Bool> {
        return Observable.just(true)
    }
    
    func saveInvitationResponse(accept: Bool, invitation: Invitation) -> Observable<Void> {
        return Observable.just(())
    }
}
