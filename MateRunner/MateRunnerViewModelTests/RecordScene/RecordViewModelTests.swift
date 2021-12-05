//
//  RecordViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/02.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class RecordViewModelTests: XCTestCase {
    private var viewModel: RecordViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: RecordViewModel.Input!
    private var output: RecordViewModel.Output!
    private let dummyDailyRecords = [
        RunningResult(
            runningSetting: RunningSetting(
                sessionId: "session-yujin-20211130105106",
                mode: .race,
                targetDistance: 5.00,
                hostNickname: "yujin",
                mateNickname: "Minji",
                dateTime: Date().startOfMonth
            ), userNickname: "yujin"
        ),
        RunningResult(
            runningSetting: RunningSetting(
                sessionId: "session-hunhun-20211130105106",
                mode: .team,
                targetDistance: 3.00,
                hostNickname: "hunhun",
                mateNickname: "Jungwon",
                dateTime: Date().startOfMonth
            ), userNickname: "hunhun"
        ),
        RunningResult(
            runningSetting: RunningSetting(
                sessionId: "session-Minji-20211130105106",
                mode: .team,
                targetDistance: 3.00,
                hostNickname: "Minji",
                mateNickname: "hunhun",
                dateTime: Date().startOfMonth
            ), userNickname: "Minji"
        )
    ]

    override func setUpWithError() throws {
        self.viewModel = RecordViewModel(
            coordinator: nil,
            recordUsecase: MockRecordUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_total_record_load() {
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([.next(10, ())])
        let refreshTestableObservable = self.scheduler.createHotObservable([.next(20, ())])
        
        let timeTextObserver = self.scheduler.createObserver(String.self)
        let distanceTextObserver = self.scheduler.createObserver(String.self)
        let calorieTextObserver = self.scheduler.createObserver(String.self)
        let totalRecordDidUpdateObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = RecordViewModel.Input(
            viewWillAppearEvent: viewDidLoadTestableObservable.asObservable(),
            refreshEvent: refreshTestableObservable.asObservable(),
            previousButtonDidTapEvent: Observable.just(()),
            nextButtonDidTapEvent: Observable.just(()),
            calendarCellDidTapEvent: Observable.just(0),
            recordCellDidTapEvent: Observable.just(0)
        )

        self.output = viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        
        self.output.timeText.subscribe(timeTextObserver).disposed(by: self.disposeBag)
        self.output.distanceText.subscribe(distanceTextObserver).disposed(by: self.disposeBag)
        self.output.calorieText.subscribe(calorieTextObserver).disposed(by: self.disposeBag)
        self.output.totalRecordDidUpdate.subscribe(totalRecordDidUpdateObserver).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(timeTextObserver.events, [
            .next(0, "00:00"),
            .next(10, "13:09"),
            .next(20, "13:09")
        ])
        
        XCTAssertEqual(distanceTextObserver.events, [
            .next(0, "0.00"),
            .next(10, "12.34"),
            .next(20, "12.34")
        ])
        
        XCTAssertEqual(calorieTextObserver.events, [
            .next(0, "0"),
            .next(10, "235"),
            .next(20, "235")
        ])
        
        XCTAssertEqual(totalRecordDidUpdateObserver.events, [
            .next(0, false),
            .next(10, true),
            .next(20, true)
        ])
    }
    
    func test_date_info_load() {
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([.next(10, ())])
        let refreshTestableObservable = self.scheduler.createHotObservable([.next(20, ())])
        let yearMonthDateTextObserver = self.scheduler.createObserver(String.self)
        let monthDayDateTextObserver = self.scheduler.createObserver(String.self)
        
        self.input = RecordViewModel.Input(
            viewWillAppearEvent: viewDidLoadTestableObservable.asObservable(),
            refreshEvent: refreshTestableObservable.asObservable(),
            previousButtonDidTapEvent: Observable.just(()),
            nextButtonDidTapEvent: Observable.just(()),
            calendarCellDidTapEvent: Observable.just(0),
            recordCellDidTapEvent: Observable.just(0)
        )

        self.output = viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        
        self.output.yearMonthDateText.subscribe(yearMonthDateTextObserver).disposed(by: self.disposeBag)
        self.output.monthDayDateText.subscribe(monthDayDateTextObserver).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(yearMonthDateTextObserver.events, [
            .next(0, Date().startOfMonth?.toDateString(format: "yyyy년 MM월") ?? ""),
            .next(10, Date().startOfMonth?.toDateString(format: "yyyy년 MM월") ?? ""),
            .next(20, Date().startOfMonth?.toDateString(format: "yyyy년 MM월") ?? "")
        ])
        
        XCTAssertEqual(monthDayDateTextObserver.events, [
            .next(0, Date().startOfMonth?.toDateString(format: "MM월 dd일") ?? "")
        ])
    }
    
    func test_daily_record_load() {
        let firstDayIndex = (Date().startOfMonth?.day ?? 1) + (Date().startOfMonth?.weekday ?? 0) - 2
        
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([.next(10, ())])
        let refreshTestableObservable = self.scheduler.createHotObservable([.next(20, ())])
        let calendarCellDidTapTestableObservable = self.scheduler.createHotObservable([.next(10, firstDayIndex)])
        let runningCountTextObserver = self.scheduler.createObserver(String.self)
        let likeCountTextObserver = self.scheduler.createObserver(String.self)
        let dailyRecordsObserver = self.scheduler.createObserver([RunningResult].self)
        let hasDailyRecordsObserver = self.scheduler.createObserver(Bool?.self)
        
        self.input = RecordViewModel.Input(
            viewWillAppearEvent: viewDidLoadTestableObservable.asObservable(),
            refreshEvent: refreshTestableObservable.asObservable(),
            previousButtonDidTapEvent: Observable.just(()),
            nextButtonDidTapEvent: Observable.just(()),
            calendarCellDidTapEvent: calendarCellDidTapTestableObservable.asObservable(),
            recordCellDidTapEvent: Observable.just(0)
        )

        self.output = viewModel.transform(from: self.input, disposeBag: self.disposeBag)
        self.output.runningCountText.subscribe(runningCountTextObserver).disposed(by: self.disposeBag)
        self.output.likeCountText.subscribe(likeCountTextObserver).disposed(by: self.disposeBag)
        self.output.dailyRecords.subscribe(dailyRecordsObserver).disposed(by: self.disposeBag)
        self.output.hasDailyRecords.subscribe(hasDailyRecordsObserver).disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(runningCountTextObserver.events, [
            .next(0, "3"),
            .next(10, "3"),
            .next(20, "3")
        ])
        
        XCTAssertEqual(likeCountTextObserver.events, [
            .next(0, "0"),
            .next(10, "0"),
            .next(20, "0")
        ])
        
        XCTAssertEqual(dailyRecordsObserver.events, [
            .next(0, []),
            .next(10, dummyDailyRecords)
        ])
        
        XCTAssertEqual(hasDailyRecordsObserver.events, [
            .next(0, false),
            .next(10, true)
        ])
    }
}
