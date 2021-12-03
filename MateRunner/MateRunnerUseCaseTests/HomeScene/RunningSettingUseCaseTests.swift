//
//  RunningSettingUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 김민지 on 2021/12/03.
//

import XCTest

import RxSwift
import RxTest

class RunningSettingUseCaseTests: XCTestCase {
    private var useCase: RunningSettingUseCase!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private let runningSetting = RunningSetting(
        sessionId: nil,
        mode: nil,
        targetDistance: nil,
        hostNickname: nil,
        mateNickname: nil,
        dateTime: nil
    )

    override func setUpWithError() throws {
        try super.setUpWithError()

        self.useCase = DefaultRunningSettingUseCase(
            runningSetting: runningSetting,
            userRepository: MockUserRepository(),
            runningRepository: MockRunningRepository()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.useCase = nil
        self.scheduler = nil
        self.disposeBag = nil
    }
    
    func test_update_host_nickname_success() {
        let testableObserver = self.scheduler.createObserver(RunningSetting.self)
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.updateHostNickname()
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.runningSetting
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        let expected = RunningSetting(
            sessionId: nil,
            mode: nil,
            targetDistance: nil,
            hostNickname: "materunner",
            mateNickname: nil,
            dateTime: nil
        )
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, self.runningSetting),
            .next(10, expected)
        ])
    }
    
    func test_update_session_id_success() {
        let testableObserver = self.scheduler.createObserver(RunningSetting.self)
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.updateSessionId()
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.runningSetting
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        let expected = RunningSetting(
            sessionId: self.createSessionId(with: "materunner", of: Date()),
            mode: nil,
            targetDistance: nil,
            hostNickname: nil,
            mateNickname: nil,
            dateTime: nil
        )
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, self.runningSetting),
            .next(10, expected)
        ])
    }
    
    func test_update_mode_success() {
        let testableObserver = self.scheduler.createObserver(RunningSetting.self)
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.updateMode(mode: .team)
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.runningSetting
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        let expected = RunningSetting(
            sessionId: nil,
            mode: .team,
            targetDistance: nil,
            hostNickname: nil,
            mateNickname: nil,
            dateTime: nil
        )
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, self.runningSetting),
            .next(10, expected)
        ])
    }

    func test_update_target_distance_success() {
        let testableObserver = self.scheduler.createObserver(RunningSetting.self)
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.updateTargetDistance(distance: 1.0)
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.runningSetting
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        let expected = RunningSetting(
            sessionId: nil,
            mode: nil,
            targetDistance: 1.0,
            hostNickname: nil,
            mateNickname: nil,
            dateTime: nil
        )
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, self.runningSetting),
            .next(10, expected)
        ])
    }

    func test_delete_mate_nickname_success() {
        let initialRunningSetting = RunningSetting(
            sessionId: nil,
            mode: nil,
            targetDistance: nil,
            hostNickname: nil,
            mateNickname: "materunner",
            dateTime: nil
        )
        self.useCase.runningSetting = BehaviorSubject(value: initialRunningSetting)
        
        let testableObserver = self.scheduler.createObserver(RunningSetting.self)
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.deleteMateNickname()
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.runningSetting
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        let expected = RunningSetting(
            sessionId: nil,
            mode: nil,
            targetDistance: nil,
            hostNickname: nil,
            mateNickname: nil,
            dateTime: nil
        )
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, initialRunningSetting),
            .next(10, expected)
        ])
    }

    func test_update_mate_nickname_success() {
        let testableObserver = self.scheduler.createObserver(RunningSetting.self)
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.updateMateNickname(nickname: "yujin")
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.runningSetting
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        let expected = RunningSetting(
            sessionId: nil,
            mode: nil,
            targetDistance: nil,
            hostNickname: nil,
            mateNickname: "yujin",
            dateTime: nil
        )
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, self.runningSetting),
            .next(10, expected)
        ])
    }

    func test_update_mate_nickname_is_running() {
        let testableObserver = self.scheduler.createObserver(Bool.self)
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.updateMateNickname(nickname: "fail")
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.mateIsRunning
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, true)
        ])
    }

    func test_update_datetime_success() {
        let testableObserver = self.scheduler.createObserver(RunningSetting.self)
        let date = Date()
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                self?.useCase.updateDateTime(date: date)
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.runningSetting
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        let expected = RunningSetting(
            sessionId: nil,
            mode: nil,
            targetDistance: nil,
            hostNickname: nil,
            mateNickname: nil,
            dateTime: date
        )
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, self.runningSetting),
            .next(10, expected)
        ])
    }
    
    private func createSessionId(with userNickname: String, of date: Date) -> String {
        return "session-\(date.fullDateTimeNumberString())-\(userNickname)"
    }
}
