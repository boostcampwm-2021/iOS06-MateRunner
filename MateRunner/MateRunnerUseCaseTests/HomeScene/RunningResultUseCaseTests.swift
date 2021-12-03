//
//  RunningResultUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 김민지 on 2021/12/03.
//

import XCTest

import RxSwift
import RxTest

class RunningResultUseCaseTests: XCTestCase {
    private var useCase: RunningResultUseCase!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let runningSetting = RunningSetting(
            sessionId: "test-session",
            mode: .team,
            targetDistance: 1.0,
            hostNickname: "minji",
            mateNickname: "yujin",
            dateTime: Date()
        )
        let runningResult = RunningResult(
            userNickname: "minji",
            runningSetting: runningSetting,
            userElapsedDistance: 0.5,
            userElapsedTime: 50,
            calorie: 100,
            points: [Point(latitude: 1.0, longitude: 1.0)],
            emojis: ["yujin": Emoji.burningHeart],
            isCanceled: false
        )
        self.useCase = DefaultRunningResultUseCase(
            firestoreRepository: MockFirestoreRepository(),
            runningResult: runningResult
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

    func test_save_running_result_success() throws {
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.useCase.saveRunningResult()
                    .subscribe(onNext: { XCTAssert(true) })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
    }
    
    func test_save_running_result_fail() throws {
        let runningSetting = RunningSetting(
            sessionId: "test-session",
            mode: .team,
            targetDistance: 1.0,
            hostNickname: "fail",
            mateNickname: "yujin",
            dateTime: Date()
        )
        let runningResult = RunningResult(
            userNickname: "fail",
            runningSetting: runningSetting,
            userElapsedDistance: 0.5,
            userElapsedTime: 50,
            calorie: 100,
            points: [Point(latitude: 1.0, longitude: 1.0)],
            emojis: ["yujin": Emoji.burningHeart],
            isCanceled: false
        )
        self.useCase.runningResult = runningResult
        
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.useCase.saveRunningResult()
                    .subscribe(onError: { _ in
                        XCTAssert(true)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
    }
    
    func test_emoji_did_select_no_mate_nickname() throws {
        let runningSetting = RunningSetting(
            sessionId: "test-session",
            mode: .team,
            targetDistance: 1.0,
            hostNickname: "minji",
            mateNickname: nil,
            dateTime: Date()
        )
        let runningResult = RunningResult(
            userNickname: "minji",
            runningSetting: runningSetting,
            userElapsedDistance: 0.5,
            userElapsedTime: 50,
            calorie: 100,
            points: [Point(latitude: 1.0, longitude: 1.0)],
            emojis: nil,
            isCanceled: false
        )
        self.useCase.runningResult = runningResult
        
        self.scheduler.createHotObservable([
            .next(10, (Emoji.burningHeart))
        ])
            .subscribe(onNext: { [weak self] emoji in
                self?.useCase.emojiDidSelect(selectedEmoji: emoji)
            })
            .disposed(by: self.disposeBag)
        
        scheduler.start()
    }
    
    func test_emoji_did_select_valid_mate_nickname() throws {
        let selectedEmojiTestableObserver = self.scheduler.createObserver(Emoji.self)
        
        self.scheduler.createHotObservable([
            .next(10, (Emoji.burningHeart))
        ])
            .subscribe(onNext: { [weak self] emoji in
                self?.useCase.emojiDidSelect(selectedEmoji: emoji)
            })
            .disposed(by: self.disposeBag)
        
        self.useCase.selectedEmoji
            .subscribe(selectedEmojiTestableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(selectedEmojiTestableObserver.events, [
            .next(10, Emoji.burningHeart)
        ])
    }
}
