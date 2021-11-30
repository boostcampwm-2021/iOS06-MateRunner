//
//  InvitationUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 김민지 on 2021/11/30.
//

 import XCTest

 import RxSwift
 import RxTest

final class InvitationUseCaseTests: XCTestCase {
    private var invitation: Invitation!
    private var invitationUseCase: InvitationUseCase!
    private var invitationRepository: InvitationRepository!
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        self.invitation = Invitation(
            sessionId: "session",
            host: "yujin",
            inviteTime: "20211129183654",
            mode: .team,
            targetDistance: 1.5,
            mate: "minji"
        )
        self.invitationRepository = MockInvitationRepository()
        self.invitationUseCase = DefaultInvitationUseCase(
            invitation: self.invitation,
            invitationRepository: self.invitationRepository
        )
    }
    
    func test_checkIsCancelled() {
        self.invitationUseCase.checkIsCancelled()
            .debug()
            .subscribe(onNext: { isCancelled in
                XCTAssert(isCancelled == true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func test_acceptInvitation() {
        self.invitationUseCase.acceptInvitation()
            .debug()
            .subscribe(
                onNext: { _ in
                    XCTAssert(true)
                },
                onError: { _ in
                    XCTAssert(false)
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func test_rejectInvitation() {
        self.invitationUseCase.rejectInvitation()
            .debug()
            .subscribe(
                onNext: { _ in
                    XCTAssert(true)
                },
                onError: { _ in
                    XCTAssert(false)
                }
            )
            .disposed(by: self.disposeBag)
    }
}
