//
//  SingleRunningResultViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class SingleRunningResultViewModelTests: XCTestCase {
    private var viewModel: SingleRunningResultViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: SingleRunningResultViewModel.Input!
    private var output: SingleRunningResultViewModel.Output!
    private var mockRunningResult = RunningResult(
        userNickname: "materunner",
        runningSetting: RunningSetting(
            sessionId: "test",
            mode: .single,
            targetDistance: 10,
            hostNickname: "materunner",
            mateNickname: nil,
            dateTime: Date(timeIntervalSince1970: 86400)
        ),
        userElapsedDistance: 1,
        userElapsedTime: 40000,
        calorie: 3,
        points: [],
        emojis: [:],
        isCanceled: false
    )
    
    override func setUpWithError() throws {
        self.viewModel = SingleRunningResultViewModel(
            coordinator: nil,
            runningResultUseCase: MockRunningResultUseCase(
                runningResult: self.mockRunningResult
            )
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler.init(initialClock: 0)
        self.input = SingleRunningResultViewModel.Input(
            viewDidLoadEvent: self.scheduler.createHotObservable([.next(10, ())]).asObservable(),
            closeButtonDidTapEvent: Observable.just(())
        )
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_distance_to_formatted_string() {
        let result = self.viewModel.transform(input, disposeBag: self.disposeBag).distance
        let expected = "1.0"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_date_time_to_formatted_string() {
        let result = self.viewModel.transform(input, disposeBag: self.disposeBag).dateTime
        let expected = "1970.01.02 - 오전 09:00"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_day_time_to_formatted_string() {
        let result = self.viewModel.transform(input, disposeBag: self.disposeBag).dayOfWeekAndTime
        let expected = "금요일 오전"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_user_time_to_formatted_string_hhmmss() {
        let result = self.viewModel.transform(input, disposeBag: self.disposeBag).time
        let expected = "11:06:40"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_calorie_to_formatted_string_hhmmss() {
        let result = self.viewModel.transform(input, disposeBag: self.disposeBag).calorie
        let expected = "3"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_single_mode_header_text() {
        let result = self.viewModel.transform(input, disposeBag: self.disposeBag).headerText
        let expected = "혼자 달리기"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_save_fail_alert_trigger() {
        let testableObserver = self.scheduler.createObserver(Bool.self)
        self.viewModel.transform(input, disposeBag: self.disposeBag)
            .saveFailAlertShouldShow
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, true)
        ])
    }
}
