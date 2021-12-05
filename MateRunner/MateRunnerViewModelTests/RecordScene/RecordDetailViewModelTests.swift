//
//  RecordDetailViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/04.
//

import CoreLocation
import XCTest

import RxRelay
import RxSwift
import RxTest

class RecordDetailViewModelTests: XCTestCase {
    private var viewModel: RecordDetailViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var output: RecordDetailViewModel.Output!

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_single_mode_running_result_load() {
        self.viewModel = RecordDetailViewModel(
            recordDetailUseCase: MockRecordDetailUseCase(
                runningResult: RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-01",
                        mode: .single,
                        targetDistance: 5.0,
                        hostNickname: "materunner",
                        mateNickname: nil,
                        dateTime: Date()
                    ),
                    userNickname: "materunner"
                )
            )
        )
        
        var output = RecordDetailViewModel.Output(
            runningMode: .race,
            dateTime: "",
            dayOfWeekAndTime: "",
            headerText: "",
            distance: "",
            calorie: "",
            time: "",
            points: [],
            region: Region(),
            isCanceled: false,
            userNickname: "",
            emojiList: [:],
            winnerText: "",
            mateResultValue: "",
            mateResultDescription: "",
            unitLabelShouldShow: false,
            totalDistance: "",
            contributionRate: ""
        )
        output = self.viewModel.createViewModelOutput()
        
        XCTAssertEqual(output.runningMode, RunningMode.single)
        XCTAssertEqual(output.headerText, "혼자 달리기")
        XCTAssertEqual(output.distance, "0.0")
        XCTAssertEqual(output.calorie, "0")
        XCTAssertEqual(output.time, "00:00")
        XCTAssertEqual(output.isCanceled, false)
        XCTAssertEqual(output.totalDistance, nil)
        XCTAssertEqual(output.contributionRate, nil)
    }
    
    func test_race_mode_running_result_load() {
        self.viewModel = RecordDetailViewModel(
            recordDetailUseCase: MockRecordDetailUseCase(
                runningResult: RaceRunningResult(
                    userNickname: "mate",
                    runningSetting: RunningSetting(
                        sessionId: "session-id",
                        mode: .race,
                        targetDistance: 5.0,
                        hostNickname: "mate",
                        mateNickname: "runner",
                        dateTime: Date()
                    ),
                    userElapsedDistance: 5.0,
                    userElapsedTime: 10,
                    calorie: 15.0,
                    points: [],
                    emojis: [:],
                    isCanceled: false,
                    mateElapsedDistance: 2.0,
                    mateElapsedTime: 5
                )
            )
        )
        
        var output = RecordDetailViewModel.Output(
            runningMode: .race,
            dateTime: "",
            dayOfWeekAndTime: "",
            headerText: "",
            distance: "",
            calorie: "",
            time: "",
            points: [],
            region: Region(),
            isCanceled: false,
            userNickname: "",
            emojiList: [:],
            winnerText: "",
            mateResultValue: "",
            mateResultDescription: "",
            unitLabelShouldShow: false,
            totalDistance: "",
            contributionRate: ""
        )
        output = self.viewModel.createViewModelOutput()
        
        XCTAssertEqual(output.runningMode, RunningMode.race)
        XCTAssertEqual(output.headerText, "runner 메이트와의 대결 👑")
        XCTAssertEqual(output.distance, "5.0")
        XCTAssertEqual(output.calorie, "15")
        XCTAssertEqual(output.time, "00:10")
        XCTAssertEqual(output.isCanceled, false)
        XCTAssertEqual(output.winnerText, "mate의 승리!")
        XCTAssertEqual(output.mateResultValue, "2.0")
        XCTAssertEqual(output.mateResultDescription, "메이트가 달린 거리")
        XCTAssertEqual(output.totalDistance, nil)
        XCTAssertEqual(output.contributionRate, nil)
    }
    
    func test_team_mode_running_result_load() {
        self.viewModel = RecordDetailViewModel(
            recordDetailUseCase: MockRecordDetailUseCase(
                runningResult: TeamRunningResult(
                    userNickname: "mate",
                    runningSetting: RunningSetting(
                        sessionId: "session-id",
                        mode: .team,
                        targetDistance: 20.0,
                        hostNickname: "mate",
                        mateNickname: "runner",
                        dateTime: Date()
                    ),
                    userElapsedDistance: 5.0,
                    userElapsedTime: 10,
                    calorie: 15.0,
                    points: [],
                    emojis: [:],
                    isCanceled: false,
                    mateElapsedDistance: 2.0,
                    mateElapsedTime: 20
                )
            )
        )
        
        var output = RecordDetailViewModel.Output(
            runningMode: .race,
            dateTime: "",
            dayOfWeekAndTime: "",
            headerText: "",
            distance: "",
            calorie: "",
            time: "",
            points: [],
            region: Region(),
            isCanceled: false,
            userNickname: "",
            emojiList: [:],
            winnerText: "",
            mateResultValue: "",
            mateResultDescription: "",
            unitLabelShouldShow: false,
            totalDistance: "",
            contributionRate: ""
        )
        output = self.viewModel.createViewModelOutput()
        
        XCTAssertEqual(output.runningMode, RunningMode.team)
        XCTAssertEqual(output.headerText, "runner 메이트와 함께한 달리기")
        XCTAssertEqual(output.distance, "5.0")
        XCTAssertEqual(output.calorie, "15")
        XCTAssertEqual(output.time, "00:10")
        XCTAssertEqual(output.isCanceled, false)
        XCTAssertEqual(output.totalDistance, "7.0")
        XCTAssertEqual(output.contributionRate, "71")
    }
}
