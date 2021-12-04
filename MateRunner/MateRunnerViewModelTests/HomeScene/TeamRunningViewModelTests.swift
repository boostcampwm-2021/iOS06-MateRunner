//
//  TeamRunningViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 김민지 on 2021/12/04.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class TeamRunningViewModelTests: XCTestCase {
    private var viewModel: TeamRunningViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var input: TeamRunningViewModel.Input!
    private var output: TeamRunningViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = TeamRunningViewModel(
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
        self.input = TeamRunningViewModel.Input(
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
        self.input = TeamRunningViewModel.Input(
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
        self.input = TeamRunningViewModel.Input(
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
        self.input = TeamRunningViewModel.Input(
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
        self.input = TeamRunningViewModel.Input(
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
        self.input = TeamRunningViewModel.Input(
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
    
    func test_total_distance_meter_to_kilometer() {
        let testableObserver = self.scheduler.createObserver(String.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = TeamRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .totalDistance
            .debug()
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "0.0"),
            .next(10, "1.0"),
            .next(10, "6.22")
        ])
    }
    
    func test_total_progress() {
        let testableObserver = self.scheduler.createObserver(Double.self)
        let testableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        self.input = TeamRunningViewModel.Input(
            viewDidLoadEvent: testableObservable.asObservable(),
            finishButtonLongPressDidBeginEvent: Observable.just(()),
            finishButtonLongPressDidCancelEvent: Observable.just(()),
            finishButtonDidTapEvent: Observable.just(())
        )
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .totalProgress
            .distinctUntilChanged()
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, 0.0),
            .next(10, 60)
        ])
    }
}
