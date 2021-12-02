//
//  LoginUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이정원 on 2021/12/02.
//

import XCTest

import RxSwift
import RxTest

class LoginUseCaseTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var userRepository: UserRepository!
    private var firestoreRepository: FirestoreRepository!
    private var loginUseCase: LoginUseCase!
    private let mockUID = "fwewth23afjeAw2fj"

    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.userRepository = MockUserRepository()
        self.firestoreRepository = MockFirestoreRepository()
        self.loginUseCase = DefaultLoginUseCase(
            repository: self.userRepository,
            firestoreRepository: self.firestoreRepository
        )
    }

    override func tearDownWithError() throws {
        self.loginUseCase = nil
        self.userRepository = nil
        self.firestoreRepository = nil
        self.disposeBag = nil
    }
    
    func test_check_registration() {
        let isRegisteredOutput = scheduler.createObserver(Bool.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginUseCase.checkRegistration(uid: self.mockUID)
            })
            .disposed(by: self.disposeBag)
        
        self.loginUseCase.isRegistered
            .subscribe(isRegisteredOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(isRegisteredOutput.events, [
            .next(10, true)
        ])
    }
    
    func test_save_login_info() {
        let isSavedOutput = scheduler.createObserver(Bool.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginUseCase.saveLoginInfo(uid: self.mockUID)
            })
            .disposed(by: self.disposeBag)
        
        self.loginUseCase.isSaved
            .subscribe(isSavedOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(isSavedOutput.events, [
            .next(10, true)
        ])
    }
}
