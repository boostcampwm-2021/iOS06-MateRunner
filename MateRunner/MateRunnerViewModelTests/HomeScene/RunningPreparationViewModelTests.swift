//
//  RunningPreparationViewModelTests.swift
//  RunningPreparationViewModelTests
//
//  Created by 전여훈 on 2021/11/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class RunningPreparationViewModelTests: XCTestCase {
    private var viewModel: RunningPreparationViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: RunningPreparationViewModel.Input!
    private var output: RunningPreparationViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = RunningPreparationViewModel(
            coordinator: nil,
            runningSettingUseCase: MockRunningSettingUseCase(),
            runningPreparationUseCase: MockRunningPreparationUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        let testableObservable = scheduler.createColdObservable([.next(10, ())])
        self.input = RunningPreparationViewModel.Input(viewDidLoadEvent: testableObservable.asObservable())
        self.output = viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = DisposeBag()
    }
    
    func test_convert_integer_time_to_string_sucess() {
        // observe output
        let timeLeft = self.scheduler.createObserver(String?.self)
        self.output.timeLeft
            .subscribe(timeLeft)
            .disposed(by: self.disposeBag)
        
        // begin
        self.scheduler.start()
        
        // test
        XCTAssertEqual(timeLeft.events, [
            .next(0, "0"),
            .next(10, "1"),
            .next(10, "2"),
            .next(10, "3")
        ])
    }
}
