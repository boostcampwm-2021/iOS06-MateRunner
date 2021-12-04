//
//  RaceRunningResultViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 김민지 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class RaceRunningResultViewModelTests: XCTestCase {
    private var viewModel: RaceRunningResultViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var input: RaceRunningResultViewModel.Input!
    private var output: RaceRunningResultViewModel.Output!
    private var mockRunningResult = RaceRunningResult(
        userNickname: "minji",
        runningSetting: RunningSetting(
            sessionId: "test",
            mode: .race,
            targetDistance: 10,
            hostNickname: "minji",
            mateNickname: "yujin",
            dateTime: Date(timeIntervalSince1970: 86400)
        ),
        userElapsedDistance: 5,
        userElapsedTime: 100,
        calorie: 3,
        points: [],
        emojis: [:],
        isCanceled: false,
        mateElapsedDistance: 6,
        mateElapsedTime: 100
    )
    
    override func setUpWithError() throws {
        self.viewModel = RaceRunningResultViewModel(
            coordinator: nil,
            runningResultUseCase: MockRunningResultUseCase(
                runningResult: self.mockRunningResult
            )
        )
        self.scheduler = TestScheduler.init(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.input = RaceRunningResultViewModel.Input(
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
    
    func test_distance_to_formatted_string() {
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).distance
        let expected = "5.0"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_date_time_to_formatted_string() {
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).dateTime
        let expected = "1970.01.02 - 오전 09:00"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_day_time_to_formatted_string() {
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).dayOfWeekAndTime
        let expected = "금요일 오전"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_user_time_to_formatted_string_hhmmss() {
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).time
        let expected = "01:40"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_calorie_to_formatted_string_hhmmss() {
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).calorie
        let expected = "3"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_race_mode_header_text_user_win() {
        let runningResult = RaceRunningResult(
            userNickname: "minji",
            runningSetting: RunningSetting(
                sessionId: "test",
                mode: .race,
                targetDistance: 10,
                hostNickname: "minji",
                mateNickname: "yujin",
                dateTime: Date(timeIntervalSince1970: 86400)
            ),
            userElapsedDistance: 6,
            userElapsedTime: 100,
            calorie: 3,
            points: [],
            emojis: [:],
            isCanceled: false,
            mateElapsedDistance: 5,
            mateElapsedTime: 100
        )
        
        self.viewModel = RaceRunningResultViewModel(
            coordinator: nil,
            runningResultUseCase: MockRunningResultUseCase(
                runningResult: runningResult
            )
        )
        
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).headerText
        let expected = "yujin 메이트와의 대결 👑"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_race_mode_header_text_canceled() {
        let runningResult = RaceRunningResult(
            userNickname: "minji",
            runningSetting: RunningSetting(
                sessionId: "test",
                mode: .race,
                targetDistance: 10,
                hostNickname: "minji",
                mateNickname: "yujin",
                dateTime: Date(timeIntervalSince1970: 86400)
            ),
            userElapsedDistance: 6,
            userElapsedTime: 100,
            calorie: 3,
            points: [],
            emojis: [:],
            isCanceled: true,
            mateElapsedDistance: 5,
            mateElapsedTime: 100
        )
        
        self.viewModel = RaceRunningResultViewModel(
            coordinator: nil,
            runningResultUseCase: MockRunningResultUseCase(
                runningResult: runningResult
            )
        )
        
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).headerText
        let expected = "yujin 메이트와의 대결"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_race_mode_header_text_user_lose() {
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).headerText
        let expected = "yujin 메이트와의 대결 😂"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_create_mate_result_with_nil_running_result() {
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
        
        self.viewModel = RaceRunningResultViewModel(
            coordinator: nil,
            runningResultUseCase: MockRunningResultUseCase(
                runningResult: runningResult
            )
        )
        
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).mateResultValue
        let expected = "00:00"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_create_mate_result_with_user_lose() {
        let result = self.viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        ).mateResultValue
        let expected = "01:40"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_save_fail_alert_trigger() {
        let testableObserver = self.scheduler.createObserver(Bool.self)
        
        self.viewModel.transform(
            from: input,
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
