//
//  NotificationViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class NotificationViewModelTests: XCTestCase {
    private var viewModel: NotificationViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: NotificationViewModel.Input!
    private var output: NotificationViewModel.Output!
    
    private var expectedNotices = [
        Notice(
            id: "notice-3",
            sender: "Jungwon",
            receiver: "hunhun",
            mode: .receiveEmoji,
            isReceived: true
        ),
        Notice(
            id: "notice-2",
            sender: "yujin",
            receiver: "hunhun",
            mode: .invite,
            isReceived: true
        ),
        Notice(
            id: "notice-1",
            sender: "Jungwon",
            receiver: "minji",
            mode: .requestMate,
            isReceived: false
        )
    ]

    override func setUpWithError() throws {
        self.viewModel = NotificationViewModel(
            coordinator: nil,
            notificationUseCase: MockNotificationUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_fetch_notices() {
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let didLoadDataTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = NotificationViewModel.Input(
            viewDidLoadEvent: viewDidLoadTestableObservable.asObservable()
        )
        
        self.output = self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        self.output.didLoadData.subscribe(didLoadDataTestableObservable).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(didLoadDataTestableObservable.events, [
            .next(10, true)
        ])
        XCTAssertEqual(self.viewModel.notices, self.expectedNotices)
    }
    
    func test_update_state() {
        let notice = Notice(
            id: "notice-1",
            sender: "Jungwon",
            receiver: "minji",
            mode: .requestMate,
            isReceived: false
        )
        
        self.input = NotificationViewModel.Input(
            viewDidLoadEvent: Observable.just(())
        )
        self.output = self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        
        self.viewModel.updateMateState(
            notice: notice,
            isAccepted: true
        )
        
        self.expectedNotices[2] = notice.copyUpdatedReceived()
        XCTAssertEqual(self.viewModel.notices, self.expectedNotices)
    }
}
