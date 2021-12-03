//
//  DistanceSettingViewModelTests.swift
//  DistanceSettingTests
//
//  Created by 전여훈 on 2021/11/05.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class DistanceSettingViewModelTests: XCTestCase {
    private var viewModel: DistanceSettingViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: DistanceSettingViewModel.Input!
    private var output: DistanceSettingViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = DistanceSettingViewModel(
            coordinator: nil,
            distanceSettingUseCase: MockDistanceSettingUseCase(),
            runningSettingUseCase: MockRunningSettingUseCase(
                runningSetting: RunningSetting(
                    sessionId: "",
                    mode: .single,
                    targetDistance: 0,
                    hostNickname: "",
                    mateNickname: "",
                    dateTime: Date()
                )
            )
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_put_two_zeros_when_text_ends_with_dot() {
        let testableTextUpdateObservable = scheduler.createColdObservable([
            .next(10, "1."),
            .next(20, "12.")
        ])
        let testableButtonTapObservable = scheduler.createColdObservable([
            .next(10, ()),
            .next(20, ())
        ])
        let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: testableButtonTapObservable.asObservable(),
            startButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
            .distanceFieldText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "1."),
            .next(10, "1.00"),
            .next(20, "12."),
            .next(20, "12.00")
        ])
    }
    
    func test_put_dot_and_two_zeros_when_no_decimal_dot() {
        let testableTextUpdateObservable = scheduler.createColdObservable([
            .next(10, "1"),
            .next(20, "12")
        ])
        let testableButtonTapObservable = scheduler.createColdObservable([
            .next(10, ()),
            .next(20, ())
        ])
        
        let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: testableButtonTapObservable.asObservable(),
            startButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
            .distanceFieldText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "1"),
            .next(10, "1.00"),
            .next(20, "12"),
            .next(20, "12.00")
        ])
    }
    
    func test_replace_zero_to_default_when_event_triggers() {
        let testableTextUpdateObservable = scheduler.createColdObservable([
            .next(10, "0"),
            .next(20, "0.")
        ])
        let testableButtonTapObservable = scheduler.createColdObservable([
            .next(10, ()),
            .next(20, ())
        ])
        let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: testableButtonTapObservable.asObservable(),
            startButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
            .distanceFieldText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "0"),
            .next(10, "5.00"),
            .next(20, "0."),
            .next(20, "5.00")
        ])
    }
    
    func test_replace_empty_text_with_zero_when_event_triggers() {
        let testableTextUpdateObservable = scheduler.createColdObservable([
            .next(10, "")
        ])
        let testableButtonTapObservable = scheduler.createColdObservable([
            .next(20, ())
        ])
        let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: testableButtonTapObservable.asObservable(),
            startButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
            .distanceFieldText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "0"),
            .next(20, "5.00")
        ])
    }
    
    func test_empty_text_to_zero_text() {
        let testableTextUpdateObservable = scheduler.createColdObservable([
            .next(10, "")
        ])
        let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: Observable.just(()),
            startButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
            .distanceFieldText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "0")
        ])
    }
    
    func test_replace_zero_when_new_number_starts_with_leading_zero() {
        let testableTextUpdateObservable = scheduler.createColdObservable([
            .next(10, "01")
        ])
        let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: Observable.just(()),
            startButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
            .distanceFieldText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "1")
        ])
    }
    
    func replace_nil_text_to_previous_text() {
        let testableTextUpdateObservable = scheduler.createColdObservable([
            .next(10, "11"),
            .next(20, "11111111111111")
        ])
        let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: Observable.just(()),
            startButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
            .distanceFieldText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "11"),
            .next(20, "11")
        ])
    }
    
}
