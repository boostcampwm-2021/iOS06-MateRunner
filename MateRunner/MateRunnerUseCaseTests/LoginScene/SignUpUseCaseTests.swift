//
//  SignUpUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이정원 on 2021/12/02.
//

import XCTest

import RxSwift
import RxTest

class SignUpUseCaseTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var userRepository: UserRepository!
    private var firestoreRepository: FirestoreRepository!
    private var signUpUseCase: SignUpUseCase!
    private let mockUID = "fwewth23afjeAw2fj"

    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.userRepository = MockUserRepository()
        self.firestoreRepository = MockFirestoreRepository()
        self.signUpUseCase = DefaultSignUpUseCase(
            repository: self.userRepository,
            firestoreRepository: self.firestoreRepository,
            uid: self.mockUID
        )
    }

    override func tearDownWithError() throws {
        self.signUpUseCase = nil
        self.userRepository = nil
        self.firestoreRepository = nil
        self.disposeBag = nil
    }
    
    func test_validate() {
        let nicknameValidationStateOuput = scheduler.createObserver(SignUpValidationState.self)
        
        self.scheduler.createColdObservable([
            .next(10, "abc"),
            .next(20, "abcdefghijklmnopqrstuvwxyz"),
            .next(30, "Jungwon!!"),
            .next(40, ""),
            .next(50, "Jungwon")
        ])
            .subscribe(onNext: { [weak self] text in
                self?.signUpUseCase.validate(text: text)
            })
            .disposed(by: self.disposeBag)
        
        self.signUpUseCase.nicknameValidationState
            .subscribe(nicknameValidationStateOuput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(nicknameValidationStateOuput.events, [
            .next(0, .empty),
            .next(10, .lowerboundViolated),
            .next(20, .upperboundViolated),
            .next(30, .invalidLetterIncluded),
            .next(40, .empty),
            .next(50, .success)
        ])
    }
    
    func test_sign_up_success() {
        self.signUpUseCase.nickname = "signUpSuccess"
        self.signUpUseCase.signUp()
            .subscribe(onNext: { result in
                XCTAssertEqual(result, true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func test_sign_up_fail() {
        self.signUpUseCase.signUp()
            .subscribe(onNext: { result in
                XCTAssertEqual(result, true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func test_save_login_info() {
        self.signUpUseCase.saveLoginInfo()
        
        let nickname = self.userRepository.fetchUserNickname()
        XCTAssertEqual(nickname, "materunner")
    }
    
    func test_shuffle_profile_emoji() {
        let selectedProfileEmojiOutput = scheduler.createObserver(String.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.signUpUseCase.shuffleProfileEmoji()
            })
            .disposed(by: self.disposeBag)
        
        self.signUpUseCase.selectedProfileEmoji
            .subscribe(selectedProfileEmojiOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        let emojis = [UInt32](0x1F601...0x1F64F).map { UnicodeScalar($0)?.description }
        let randomEmojiOutput = selectedProfileEmojiOutput.events.last?.value.element
    
        XCTAssertEqual(selectedProfileEmojiOutput.events.first, .next(0, "👩🏻‍🚀"))
        XCTAssert(emojis.contains(randomEmojiOutput))
    }
}
