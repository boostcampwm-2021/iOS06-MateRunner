//
//  EmojiUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이정원 on 2021/12/02.
//

import XCTest

import RxSwift
import RxTest

class EmojiUseCaseTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var firestoreRepository: FirestoreRepository!
    private var mateRepository: MateRepository!
    private var userRepository: UserRepository!
    private var emojiUseCase: EmojiUseCase!
    private let mockEmoji = Emoji.thumbsUp

    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.firestoreRepository = MockFirestoreRepository()
        self.mateRepository = MockMateRepository()
        self.userRepository = MockUserRepository()
        self.emojiUseCase = DefaultEmojiUseCase(
            firestoreRepository: self.firestoreRepository,
            mateRepository: self.mateRepository,
            userRepository: self.userRepository,
            delegate: MockEmojiDidSelectDelegate()
        )
        self.emojiUseCase.runningID = "session-Jungwon-20211130105106"
        self.emojiUseCase.mateNickname = "hunhun"
    }

    override func tearDownWithError() throws {
        self.emojiUseCase = nil
        self.firestoreRepository = nil
        self.mateRepository = nil
        self.userRepository = nil
        self.disposeBag = nil
    }
    
    func test_save_sent_emoji() {
        let selectedEmojiOutput = scheduler.createObserver(Emoji.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.emojiUseCase.saveSentEmoji(self.mockEmoji)
            })
            .disposed(by: self.disposeBag)
        
        self.emojiUseCase.selectedEmoji
            .subscribe(selectedEmojiOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(selectedEmojiOutput.events, [
            .next(10, self.mockEmoji)
        ])
    }
    
    func test_select_emoji() {
        let selectedEmojiOutput = scheduler.createObserver(Emoji.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.emojiUseCase.selectEmoji(self.mockEmoji)
            })
            .disposed(by: self.disposeBag)
        
        self.emojiUseCase.selectedEmoji
            .debug()
            .subscribe(selectedEmojiOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(selectedEmojiOutput.events, [
            .next(10, self.mockEmoji)
        ])
    }
    
    func test_send_compliment_emoji() {
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.emojiUseCase.sendComplimentEmoji()
                XCTAssert(true)
            })
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
    }
}
