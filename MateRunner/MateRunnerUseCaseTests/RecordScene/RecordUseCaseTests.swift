//
//  RecordUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이정원 on 2021/12/01.
//

import XCTest

import RxSwift
import RxTest

class RecordUseCaseTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var userRepository: UserRepository!
    private var firestoreRepository: FirestoreRepository!
    private var recordUseCase: RecordUseCase!
    
    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.userRepository = MockUserRepository()
        self.firestoreRepository = MockFirestoreRepository()
        self.recordUseCase = DefaultRecordUseCase(
            userRepository: self.userRepository,
            firestoreRepository: self.firestoreRepository
        )
    }
    
    override func tearDownWithError() throws {
        self.recordUseCase = nil
        self.userRepository = nil
        self.firestoreRepository = nil
        self.disposeBag = nil
    }
    
    func test_load_total_record() {
        let totalRecordOutput = scheduler.createObserver(PersonalTotalRecord.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.recordUseCase.loadTotalRecord()
            })
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.totalRecord
            .subscribe(totalRecordOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(totalRecordOutput.events, [
            .next(10, PersonalTotalRecord(distance: 56.0, time: 204, calorie: 1045.5))
        ])
    }
    
    func test_load_monthly_record() {
        let monthlyRecordsOutput = scheduler.createObserver([RunningResult].self)
        let runningCountOutput = scheduler.createObserver(Int.self)
        let likeCountOutput = scheduler.createObserver(Int.self)
        
        var expectedMonthlyRecords = [RunningResult]()
        
        [
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-Jungwon-20211130105106",
                    mode: .race,
                    targetDistance: 5.00,
                    hostNickname: "Jungwon",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ),
                userNickname: "Jungwon"
            ),
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-Minji-20211130105106",
                    mode: .team,
                    targetDistance: 3.00,
                    hostNickname: "Minji",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ),
                userNickname: "Minji"
            ),
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-yujin-20211130105106",
                    mode: .team,
                    targetDistance: 3.00,
                    hostNickname: "yujin",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ),
                userNickname: "yujin"
            )
        ].forEach({ record in
            record.updateEmoji(to: ["hunhun": .clap, "Minji": .ribbonHeart, "Jungwon": .fire])
            expectedMonthlyRecords.append(record)
        })
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.recordUseCase.loadMonthlyRecord()
            })
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.monthlyRecords
            .subscribe(monthlyRecordsOutput)
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.runningCount
            .subscribe(runningCountOutput)
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.likeCount
            .subscribe(likeCountOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(monthlyRecordsOutput.events, [
            .next(0, []),
            .next(10, expectedMonthlyRecords)
        ])
        
        XCTAssertEqual(runningCountOutput.events, [
            .next(10, 3)
        ])
        
        XCTAssertEqual(likeCountOutput.events, [
            .next(10, 9)
        ])
    }
    
    func test_update_to_next_month() {
        let monthOutput = scheduler.createObserver(Date?.self)
        let selectedDayOutput = scheduler.createObserver(Int?.self)
        
        let currentMonth = Date().startOfMonth
        let today = Date().day
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.recordUseCase.updateMonth(toNext: true)
            })
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.month
            .subscribe(monthOutput)
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.selectedDay
            .map { $0?.day }
            .subscribe(selectedDayOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(monthOutput.events, [
            .next(0, currentMonth),
            .next(10, currentMonth?.nextMonth)
        ])
        
        XCTAssertEqual(selectedDayOutput.events, [
            .next(0, today),
            .next(10, 1)
        ])
    }
    
    func test_update_to_previous_month() {
        let monthOutput = scheduler.createObserver(Date?.self)
        let selectedDayOutput = scheduler.createObserver(Int?.self)
        
        let currentMonth = Date().startOfMonth
        let today = Date().day
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.recordUseCase.updateMonth(toNext: false)
            })
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.month
            .subscribe(monthOutput)
            .disposed(by: self.disposeBag)
        
        self.recordUseCase.selectedDay
            .map { $0?.day }
            .subscribe(selectedDayOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(monthOutput.events, [
            .next(0, currentMonth),
            .next(10, currentMonth?.previousMonth)
        ])
        
        XCTAssertEqual(selectedDayOutput.events, [
            .next(0, today),
            .next(10, 1)
        ])
    }

}
