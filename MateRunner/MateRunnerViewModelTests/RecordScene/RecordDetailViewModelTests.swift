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
        self.viewModel = RecordDetailViewModel(
            recordDetailUseCase: MockRecordDetailUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_running_result_load() {
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
}
