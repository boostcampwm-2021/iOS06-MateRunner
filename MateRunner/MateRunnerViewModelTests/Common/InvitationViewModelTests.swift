//
//  InvitationViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class InvitationViewModelTests: XCTestCase {
    private var viewModel: InvitationViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: InvitationViewModel.Input!
    private var output: InvitationViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = InvitationViewModel(
            coordinator: nil,
            invitationUseCase: MockInvitationUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }

    func test_accept_or_reject_button_selection() {
        let acceptButtonTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let rejectButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, ())
        ])
        
        let cancelAlertShowTestableObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = InvitationViewModel.Input(
            acceptButtonDidTapEvent: acceptButtonTestableObservable.asObservable(),
            rejectButtonDidTapEvent: rejectButtonTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .cancelledAlertShouldShow
            .subscribe(cancelAlertShowTestableObserver)
            .disposed(by: self.disposeBag)

        self.scheduler.start()
        
        XCTAssertEqual(cancelAlertShowTestableObserver.events, [
            .next(10, false),
            .next(20, true)
        ])
    }
    
    func test_output_invitation_info_success() {
        let acceptButtonTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let rejectButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, ())
        ])
        
        let cancelAlertShowTestableObserver = self.scheduler.createObserver(Bool.self)
        var hostTestString = ""
        var modeTestString = ""
        var targetDistanceTestString = ""
        
        self.input = InvitationViewModel.Input(
            acceptButtonDidTapEvent: acceptButtonTestableObservable.asObservable(),
            rejectButtonDidTapEvent: rejectButtonTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .cancelledAlertShouldShow
            .subscribe(cancelAlertShowTestableObserver)
            .disposed(by: self.disposeBag)
        
        hostTestString = self.viewModel.transform(from: input, disposeBag: self.disposeBag).host
        modeTestString = self.viewModel.transform(from: input, disposeBag: self.disposeBag).mode
        targetDistanceTestString = self.viewModel.transform(from: input, disposeBag: self.disposeBag).targetDistance

        self.scheduler.start()
        
        XCTAssertEqual(hostTestString, "materunner")
        XCTAssertEqual(modeTestString, "🤜 경쟁 모드")
        XCTAssertEqual(targetDistanceTestString, "5.00")
    }
}
