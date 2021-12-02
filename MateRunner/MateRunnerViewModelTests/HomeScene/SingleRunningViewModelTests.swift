//
//  SingleRunningViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/11/06.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class SingleRunningViewModelTests: XCTestCase {
    private var viewModel: SingleRunningViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: SingleRunningViewModel.Input!
    private var output: SingleRunningViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = SingleRunningViewModel(
            coordinator: nil,
            runningUseCase: MockSingleRunningUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler.init(initialClock: 0)
        
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_seconds_to_mmss_format() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = SingleRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .timeSpent
            .take(2)
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, "00:00"),
            .next(10, "00:10"),
            .completed(10)
        ])
    }
    
    func test_seconds_to_hhmmss_format() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = SingleRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .timeSpent
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, "00:00"),
            .next(10, "00:10"),
            .next(10, "13:36:40")
        ])
    }
    
    func test_timer_time_left_to_text() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = SingleRunningViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            finishButtonLongPressDidBeginEvent: testableObservable.asObservable(),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .cancelTimeLeft
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, "종료"),
            .next(10, "2"),
            .next(10, "1")
        ])
    }
    
    func test_timer_pop_up_show_show() {
        let testableObserver = self.scheduler.createObserver(Bool.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = SingleRunningViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            finishButtonLongPressDidBeginEvent: testableObservable.asObservable(),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .popUpShouldShow
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, true),
            .next(10, true),
            .next(10, true)
        ])
    }
    
    func test_calorie_format() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = SingleRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .calorie
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, "20")
        ])
    }
    
    func test_distance_meter_to_kilometer() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = SingleRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .distance
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "0.0"),
            .next(10, "10.12")
        ])
    }
    
    func test_progress() {
        let testableObserver = self.scheduler.createObserver(Double.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = SingleRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .progress
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, 0.0),
            .next(10, 50)
        ])
    }
}
