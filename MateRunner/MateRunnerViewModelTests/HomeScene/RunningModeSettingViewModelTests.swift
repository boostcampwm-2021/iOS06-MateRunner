//
//  RunningModeSettingViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/01.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class RunningModeSettingViewModelTests: XCTestCase {
    private var viewModel: RunningModeSettingViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: RunningModeSettingViewModel.Input!
    private var output: RunningModeSettingViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = RunningModeSettingViewModel(
            coordinator: nil,
            runningSettingUseCase: MockRunningSettingUseCase())
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_single_mode_selection() {
        let sinlgeButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, ())
        ])
        let teamButtonTestableObservable = self.scheduler.createHotObservable([
            .next(10, () )
        ])
        let modeSelectionTestableObserver = self.scheduler.createObserver(RunningMode?.self)
        
        self.input = RunningModeSettingViewModel.Input(
            singleButtonTapEvent: sinlgeButtonTestableObservable.asObservable(),
            mateButtonTapEvent: teamButtonTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .runningMode
            .skip(2)
            .subscribe(modeSelectionTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(modeSelectionTestableObserver.events, [
            .next(20, .single)
        ])
    }
    
    func test_race_mode_selection() {
        let sinlgeButtonTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let teamButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, () )
        ])
        let modeSelectionTestableObserver = self.scheduler.createObserver(RunningMode?.self)
        
        self.input = RunningModeSettingViewModel.Input(
            singleButtonTapEvent: sinlgeButtonTestableObservable.asObservable(),
            mateButtonTapEvent: teamButtonTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .runningMode
            .skip(2)
            .subscribe(modeSelectionTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(modeSelectionTestableObserver.events, [
            .next(20, .race)
        ])
    }
}
