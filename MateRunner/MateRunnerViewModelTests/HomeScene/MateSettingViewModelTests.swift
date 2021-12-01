//
//  MateSettingViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/01.
//

import Foundation

import XCTest

import RxRelay
import RxSwift
import RxTest

final class MateSettingViewModelTests: XCTestCase {
    private var viewModel: MateSettingViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: MateSettingViewModel.Input!
    private var output: MateSettingViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = MateSettingViewModel(
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
    
    func test_mate_selection_success() {
        let mateSelectionTestableObservable = self.scheduler.createHotObservable([
            .next(10, "yujin")
        ])
        let mateSelectionTestableObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = MateSettingViewModel.Input(
            viewWillAppearEvent: Observable.just(()),
            mateDidSelectEvent: mateSelectionTestableObservable.asObservable()
        )
        
        self.viewModel.transform(input: input, disposeBag: self.disposeBag)
            .mateIsNowRunningAlertShouldShow
            .subscribe(mateSelectionTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(mateSelectionTestableObserver.events, [
            .next(10, false)
        ])
    }
    
    func test_mate_selection_mate_is_now_running() {
        let mateSelectionTestableObservable = self.scheduler.createHotObservable([
            .next(10, "running")
        ])
        let mateSelectionTestableObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = MateSettingViewModel.Input(
            viewWillAppearEvent: Observable.just(()),
            mateDidSelectEvent: mateSelectionTestableObservable.asObservable()
        )
        
        self.viewModel.transform(input: input, disposeBag: self.disposeBag)
            .mateIsNowRunningAlertShouldShow
            .subscribe(mateSelectionTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(mateSelectionTestableObserver.events, [
            .next(10, true)
        ])
    }
}
