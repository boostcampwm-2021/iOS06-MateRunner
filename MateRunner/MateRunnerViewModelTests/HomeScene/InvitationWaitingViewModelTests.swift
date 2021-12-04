//
//  InvitationWaitingViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 김민지 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class InvitationWaitingViewModelTests: XCTestCase {
    private var viewModel: InvitationWaitingViewModel!
    private var input: InvitationWaitingViewModel.Input!
    private var output: InvitationWaitingViewModel.Output!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.scheduler = nil
        self.disposeBag = nil
    }

    func test_update_invitation_status_accepted() throws {
        let runningSetting = RunningSetting(
            sessionId: "accepted-session",
            mode: .team,
            targetDistance: 1.0,
            hostNickname: "minji",
            mateNickname: "yujin",
            dateTime: Date()
        )
        
        self.viewModel = InvitationWaitingViewModel(
            coordinator: nil,
            invitationWaitingUseCase: MockInvitationWaitingUseCase(runningSetting: runningSetting)
        )
        
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([
                    .next(10, ())
                ])
        
        let requestSuccessTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = InvitationWaitingViewModel.Input(
            viewDidLoadEvent: viewDidLoadTestableObservable.asObservable()
        )

        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .requestSuccess
            .subscribe(requestSuccessTestableObservable)
            .disposed(by: self.disposeBag)

        self.scheduler.start()

        XCTAssertEqual(requestSuccessTestableObservable.events, [
            .next(10, true)
        ])
    }
    
    func test_update_invitation_status_rejected() throws {
        let runningSetting = RunningSetting(
            sessionId: "rejected-session",
            mode: .team,
            targetDistance: 1.0,
            hostNickname: "minji",
            mateNickname: "yujin",
            dateTime: Date()
        )
        
        self.viewModel = InvitationWaitingViewModel(
            coordinator: nil,
            invitationWaitingUseCase: MockInvitationWaitingUseCase(runningSetting: runningSetting)
        )
        
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([
                    .next(10, ())
                ])
        
        let isRejectedTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = InvitationWaitingViewModel.Input(
            viewDidLoadEvent: viewDidLoadTestableObservable.asObservable()
        )

        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .isRejected
            .subscribe(isRejectedTestableObservable)
            .disposed(by: self.disposeBag)

        self.scheduler.start()

        XCTAssertEqual(isRejectedTestableObservable.events, [
            .next(10, true)
        ])
    }
    
    func test_update_invitation_status_canceled() throws {
        let runningSetting = RunningSetting(
            sessionId: "canceled-session",
            mode: .team,
            targetDistance: 1.0,
            hostNickname: "minji",
            mateNickname: "yujin",
            dateTime: Date()
        )
        
        self.viewModel = InvitationWaitingViewModel(
            coordinator: nil,
            invitationWaitingUseCase: MockInvitationWaitingUseCase(runningSetting: runningSetting)
        )
        
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([
                    .next(10, ())
                ])
        
        let isCanceledTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = InvitationWaitingViewModel.Input(
            viewDidLoadEvent: viewDidLoadTestableObservable.asObservable()
        )

        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .isCanceled
            .subscribe(isCanceledTestableObservable)
            .disposed(by: self.disposeBag)

        self.scheduler.start()

        XCTAssertEqual(isCanceledTestableObservable.events, [
            .next(10, true)
        ])
    }
    
    func test_alert_confirm_button_did_tap() throws {
        let runningSetting = RunningSetting(
            sessionId: "canceled-session",
            mode: .team,
            targetDistance: 1.0,
            hostNickname: "minji",
            mateNickname: "yujin",
            dateTime: Date()
        )
        
        self.viewModel = InvitationWaitingViewModel(
            coordinator: nil,
            invitationWaitingUseCase: MockInvitationWaitingUseCase(runningSetting: runningSetting)
        )
        
        self.viewModel.alertConfirmButtonDidTap()
    }
}
