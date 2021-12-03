//
//  MateRunningModeSettingViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/01.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class MateRunningModeSettingViewModelTests: XCTestCase {
    private var viewModel: MateRunningModeSettingViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: MateRunningModeSettingViewModel.Input!
    private var output: MateRunningModeSettingViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = MateRunningModeSettingViewModel(
            coordinator: nil,
            runningSettingUseCase: MockRunningSettingUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_race_mode_selection() {
        let raceButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, ())
        ])
        let teamButtonTestableObservable = self.scheduler.createHotObservable([
            .next(10, () )
        ])
        
        let modeSelectionTestableObserver = self.scheduler.createObserver(RunningMode.self)
        
        self.input = MateRunningModeSettingViewModel.Input(
            raceModeButtonDidTapEvent: raceButtonTestableObservable.asObservable(),
            teamModeButtonDidTapEvent: teamButtonTestableObservable.asObservable(),
            nextButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .mode
            .skip(2)
            .subscribe(modeSelectionTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(modeSelectionTestableObserver.events, [
            .next(20, .race)
        ])
    }
    
    func test_team_mode_selection_first() {
        let raceButtonTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let teamButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, () )
        ])
        
        let modeSelectionTestableObserver = self.scheduler.createObserver(RunningMode.self)
        
        self.input = MateRunningModeSettingViewModel.Input(
            raceModeButtonDidTapEvent: raceButtonTestableObservable.asObservable(),
            teamModeButtonDidTapEvent: teamButtonTestableObservable.asObservable(),
            nextButtonDidTapEvent: Observable.just(())
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .mode
            .skip(2)
            .subscribe(modeSelectionTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(modeSelectionTestableObserver.events, [
            .next(20, .team)
        ])
    }
}
