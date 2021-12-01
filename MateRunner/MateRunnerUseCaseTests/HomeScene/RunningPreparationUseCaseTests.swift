//
//  RunningPreparationUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/01.
//

import Foundation

import XCTest

import RxSwift
import RxTest

final class RunningPreparationUseCaseTests: XCTestCase {
    private var useCase: RunningPreparationUseCase!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        self.useCase = DefaultRunningPreparationUseCase()
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.useCase = nil
        self.disposeBag = nil
    }
    
    func test_timeleft_emmit() {
        let timerTestableObserver = self.scheduler.createObserver(Int.self)
        let expectation = XCTestExpectation(description: "TimerExpectation")
    
        self.useCase.executeTimer()
        
        self.useCase.timeLeft
            .subscribe(
                onNext: { timerTestableObserver.onNext($0) },
                onCompleted: { expectation.fulfill() })
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertEqual(timerTestableObserver.events, [
            .next(0, 3),
            .next(0, 2),
            .next(0, 1)
        ])
    }
}
