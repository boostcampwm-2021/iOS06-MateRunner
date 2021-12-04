//
//  TeamRunningResultViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 김민지 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class TeamRunningResultViewModelTests: XCTestCase {
    private var viewModel: TeamRunningResultViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var input: TeamRunningResultViewModel.Input!
    private var output: TeamRunningResultViewModel.Output!
    private var mockRunningResult = TeamRunningResult(
        userNickname: "minji",
        runningSetting: RunningSetting(
            sessionId: "test",
            mode: .team,
            targetDistance: 10,
            hostNickname: "minji",
            mateNickname: "yujin",
            dateTime: Date(timeIntervalSince1970: 86400)
        ),
        userElapsedDistance: 4,
        userElapsedTime: 100,
        calorie: 3,
        points: [],
        emojis: [:],
        isCanceled: false,
        mateElapsedDistance: 6,
        mateElapsedTime: 100
    )
    
    override func setUpWithError() throws {
        self.viewModel = TeamRunningResultViewModel(
            coordinator: nil,
            runningResultUseCase: MockRunningResultUseCase(
                runningResult: self.mockRunningResult
            )
        )
        self.scheduler = TestScheduler.init(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.input = TeamRunningResultViewModel.Input(
            viewDidLoadEvent: self.scheduler.createHotObservable([.next(10, ())]).asObservable(),
            closeButtonDidTapEvent: Observable.just(()),
            emojiButtonDidTapEvent: self.scheduler.createHotObservable([.next(10, ())]).asObservable()
        )
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.scheduler = nil
        self.disposeBag = nil
    }
    
    func test_user_distance_to_formatted_string() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).userDistance
        let expected = "4.0"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_total_distance_to_formatted_string() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).totalDistance
        let expected = "10.0"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_contribution_rate_to_formatted_string() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).contributionRate
        let expected = "40"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_date_time_to_formatted_string() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).dateTime
        let expected = "1970.01.02 - 오전 09:00"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_day_time_to_formatted_string() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).dayOfWeekAndTime
        let expected = "금요일 오전"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_user_time_to_formatted_string_hhmmss() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).time
        let expected = "01:40"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_calorie_to_formatted_string_hhmmss() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).calorie
        let expected = "3"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_team_mode_header_text() {
        let result = self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        ).headerText
        let expected = "yujin 메이트와 함께한 달리기"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_create_viewmodel_output_with_nil_running_result() {
        let runningResult = RunningResult(
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
        
        self.viewModel = TeamRunningResultViewModel(
            coordinator: nil,
            runningResultUseCase: MockRunningResultUseCase(
                runningResult: runningResult
            )
        )
        
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).userDistance
        let expected = "---"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_save_fail_alert_trigger() {
        let testableObserver = self.scheduler.createObserver(Bool.self)
        
        self.viewModel.transform(
            from: self.input,
            disposeBag: self.disposeBag
        )
            .saveFailAlertShouldShow
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, true)
        ])
    }
}
