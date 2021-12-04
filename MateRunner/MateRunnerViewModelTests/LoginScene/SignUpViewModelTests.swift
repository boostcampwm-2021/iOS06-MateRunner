//
//  SignUpViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class SignUpViewModelTests: XCTestCase {
    private var viewModel: SignUpViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: SignUpViewModel.Input!
    private var output: SignUpViewModel.Output!

    override func setUpWithError() throws {
        self.viewModel = SignUpViewModel(
            coordinator: nil,
            signUpUseCase: MockSignUpUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_profile_emoji() {
        let shuffleButtonDidTapObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let profileEmojiObserver = self.scheduler.createObserver(String.self)
        
        self.input = SignUpViewModel.Input(
            nicknameTextFieldDidEditEvent: Observable.just(""),
            shuffleButtonDidTapEvent: shuffleButtonDidTapObservable.asObservable(),
            heightTextFieldDidTapEvent: Observable.just(()),
            heightPickerSelectedRow: Observable.just(0),
            weightTextFieldDidTapEvent: Observable.just(()),
            weightPickerSelectedRow: Observable.just(0),
            doneButtonDidTapEvent: Observable.just(())
        )
        
        self.output = self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        self.output.profileEmoji.subscribe(profileEmojiObserver).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(profileEmojiObserver.events.first, .next(0, "👩🏻‍🚀"))
        let emojis = [UInt32](0x1F601...0x1F64F).compactMap { UnicodeScalar($0)?.description }
        
        if let randomEmoji = profileEmojiObserver.events.last?.value.element {
            XCTAssert(emojis.contains(randomEmoji))
        }
    }
    
    func test_nickname() {
        let nicknameTextFieldDidEditObservable = self.scheduler.createHotObservable([
            .next(10, "abc"),
            .next(20, "abcdefghijklmnopqrstuvwxyz"),
            .next(30, "Jungwon!!"),
            .next(40, "Jungwon")
        ])
        
        let nicknameFieldTextObserver = self.scheduler.createObserver(String?.self)
        let validationErrorMessageObserver = self.scheduler.createObserver(String?.self)
        let doneButtonShouldEnableObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = SignUpViewModel.Input(
            nicknameTextFieldDidEditEvent: nicknameTextFieldDidEditObservable.asObservable(),
            shuffleButtonDidTapEvent: Observable.just(()),
            heightTextFieldDidTapEvent: Observable.just(()),
            heightPickerSelectedRow: Observable.just(0),
            weightTextFieldDidTapEvent: Observable.just(()),
            weightPickerSelectedRow: Observable.just(0),
            doneButtonDidTapEvent: Observable.just(())
        )
        
        self.output = self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        self.output.nicknameFieldText.subscribe(nicknameFieldTextObserver).disposed(by: self.disposeBag)
        self.output.validationErrorMessage.subscribe(validationErrorMessageObserver).disposed(by: self.disposeBag)
        self.output.doneButtonShouldEnable.subscribe(doneButtonShouldEnableObserver).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(nicknameFieldTextObserver.events, [
            .next(0, ""),
            .next(10, "abc"),
            .next(20, "abcdefghijklmnopqrstuvwxyz"),
            .next(30, "Jungwon!!"),
            .next(40, "Jungwon")
        ])
        
        XCTAssertEqual(validationErrorMessageObserver.events, [
            .next(0, ""),
            .next(10, "최소 5자 이상 입력해주세요"),
            .next(20, "최대 20자까지만 가능해요"),
            .next(30, "영문과 숫자만 입력할 수 있어요"),
            .next(40, "")
        ])
        
        XCTAssertEqual(doneButtonShouldEnableObserver.events, [
            .next(0, false),
            .next(10, false),
            .next(20, false),
            .next(30, false),
            .next(40, true)
        ])
    }
    
    func test_height_weight() {
        let heightPickerSelectedRowObservable = self.scheduler.createHotObservable([
            .next(10, 69),
            .next(20, 71)
        ])
        
        let weightPickerSelectedRowObservable = self.scheduler.createHotObservable([
            .next(10, 39),
            .next(20, 41)
        ])
        
        let heightRangeObserver = self.scheduler.createObserver([String].self)
        let weightRangeObserver = self.scheduler.createObserver([String].self)
        let heightFieldTextObserver = self.scheduler.createObserver(String.self)
        let weightFieldTextObserver = self.scheduler.createObserver(String.self)
        
        self.input = SignUpViewModel.Input(
            nicknameTextFieldDidEditEvent: Observable.just(""),
            shuffleButtonDidTapEvent: Observable.just(()),
            heightTextFieldDidTapEvent: Observable.just(()),
            heightPickerSelectedRow: heightPickerSelectedRowObservable.asObservable(),
            weightTextFieldDidTapEvent: Observable.just(()),
            weightPickerSelectedRow: weightPickerSelectedRowObservable.asObservable(),
            doneButtonDidTapEvent: Observable.just(())
        )
        
        self.output = self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        self.output.heightRange.subscribe(heightRangeObserver).disposed(by: self.disposeBag)
        self.output.weightRange.subscribe(weightRangeObserver).disposed(by: self.disposeBag)
        self.output.heightFieldText.subscribe(heightFieldTextObserver).disposed(by: self.disposeBag)
        self.output.weightFieldText.subscribe(weightFieldTextObserver).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(heightRangeObserver.events, [
            .next(0, Height.range.map { "\($0) cm" })
        ])
        
        XCTAssertEqual(weightRangeObserver.events, [
            .next(0, Weight.range.map { "\($0) kg" })
        ])
        
        XCTAssertEqual(heightFieldTextObserver.events, [
            .next(0, "170 cm"),
            .next(10, "169 cm"),
            .next(20, "171 cm")
        ])
        
        XCTAssertEqual(weightFieldTextObserver.events, [
            .next(0, "60 kg"),
            .next(10, "59 kg"),
            .next(20, "61 kg")
        ])
    }
}
