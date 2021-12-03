//
//  LoginViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class LoginViewModelTests: XCTestCase {
    private var viewModel: LoginViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: LoginViewModel.Input!
    private var output: LoginViewModel.Output!
    private var loginUseCase: LoginUseCase!
    
    override func setUpWithError() throws {
        self.loginUseCase = MockLoginUseCase()
        self.viewModel = LoginViewModel(
            coordinator: nil,
            loginUseCase: self.loginUseCase
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
        self.loginUseCase = nil
    }
    
    func test_is_term_agreed() {
        let agreeButtonDidTapTestableObservable = self.scheduler.createHotObservable([
            .next(10, ()),
            .next(20, ())
        ])
        
        let isAgreedObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = LoginViewModel.Input(
            agreeButtonDidTapEvent: agreeButtonDidTapTestableObservable.asObservable(),
            termsButtonDidTapEvent: Observable.just(())
        )
        
        self.output = self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        self.output.isAgreed.subscribe(isAgreedObserver).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(isAgreedObserver.events, [
            .next(10, true),
            .next(20, false)
        ])
    }
    
    func testRegistration() {
        let isRegisteredOutput = scheduler.createObserver(Bool.self)
        
        self.scheduler.createColdObservable([
            .next(10, "mockUID"),
            .next(20, "registeredMockUID")
        ])
            .subscribe(onNext: { [weak self] uid in
                guard let self = self else { return }
                self.viewModel.checkRegistration(uid: uid)
            })
            .disposed(by: self.disposeBag)
        
        self.loginUseCase.isRegistered
            .subscribe(isRegisteredOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()

        XCTAssertEqual(isRegisteredOutput.events, [
            .next(10, false),
            .next(20, true)
        ])
    }
}
