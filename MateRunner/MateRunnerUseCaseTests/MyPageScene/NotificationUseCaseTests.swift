//
//  NotificationUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이정원 on 2021/12/01.
//

import XCTest

import RxSwift
import RxTest

class NotificationUseCaseTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var userRepository: UserRepository!
    private var firestoreRepository: FirestoreRepository!
    private var notificationUseCase: NotificationUseCase!
    
    private let expectedNotices = [
        Notice(
            id: "notice-1",
            sender: "Jungwon",
            receiver: "minji",
            mode: .requestMate,
            isReceived: false
        ),
        Notice(
            id: "notice-2",
            sender: "yujin",
            receiver: "hunhun",
            mode: .invite,
            isReceived: true
        ),
        Notice(
            id: "notice-3",
            sender: "Jungwon",
            receiver: "hunhun",
            mode: .receiveEmoji,
            isReceived: true
        )
    ]

    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.userRepository = MockUserRepository()
        self.firestoreRepository = MockFirestoreRepository()
        self.notificationUseCase = DefaultNotificationUseCase(
            userRepository: self.userRepository,
            firestoreRepository: self.firestoreRepository
        )
    }

    override func tearDownWithError() throws {
        self.notificationUseCase = nil
        self.userRepository = nil
        self.firestoreRepository = nil
        self.disposeBag = nil
    }
    
    func test_fetch_notices() {
        let noticesOutput = scheduler.createObserver([Notice].self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.notificationUseCase.fetchNotices()
            })
            .disposed(by: self.disposeBag)
        
        self.notificationUseCase.notices
            .subscribe(noticesOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(noticesOutput.events, [
            .next(10, self.expectedNotices)
        ])
    }
    
    func test_update_mate_state() {
        let noticesOutput = scheduler.createObserver([Notice].self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.notificationUseCase.updateMateState(
                    notice: Notice(
                        id: "notice-1",
                        sender: "Jungwon",
                        receiver: "minji",
                        mode: .requestMate,
                        isReceived: false
                    ),
                    isAccepted: true
                )
            })
            .disposed(by: self.disposeBag)
        
        self.notificationUseCase.notices
            .subscribe(noticesOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(noticesOutput.events, [
            .next(10, self.expectedNotices)
        ])
    }
}
