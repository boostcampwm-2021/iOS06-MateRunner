//
//  RaceRunningViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 김민지 on 2021/12/04.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class RaceRunningViewModelTests: XCTestCase {
    private var viewModel: RaceRunningViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var input: RaceRunningViewModel.Input!
    private var output: RaceRunningViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = RaceRunningViewModel(
            coordinator: nil,
            runningUseCase: MockMateRunningUseCase()
        )
        self.scheduler = TestScheduler.init(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.scheduler = nil
        self.disposeBag = nil
    }
    
    func test_seconds_to_mmss_format() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = RaceRunningViewModel.Input(
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
        self.input = RaceRunningViewModel.Input(
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
        self.input = RaceRunningViewModel.Input(
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
        self.input = RaceRunningViewModel.Input(
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
        self.input = RaceRunningViewModel.Input(
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
    
    func test_my_distance_meter_to_kilometer() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = RaceRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .myDistance
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "0.0"),
            .next(10, "5.22")
        ])
    }
    
    func test_mate_distance_meter_to_kilometer() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = RaceRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .mateDistance
            .debug()
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "0.0"),
            .next(10, "1.0")
        ])
    }
    
    func test_my_progress() {
        let testableObserver = self.scheduler.createObserver(Double.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = RaceRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .myProgress
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, 0.0),
            .next(10, 50)
        ])
    }
    
    func test_mate_progress() {
        let testableObserver = self.scheduler.createObserver(Double.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = RaceRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .mateProgress
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, 0.0),
            .next(10, 10)
        ])
    }
}
