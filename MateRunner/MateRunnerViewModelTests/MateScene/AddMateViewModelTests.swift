//
//  AddMateViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/04.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class AddMateViewModelTests: XCTestCase {
    private var viewModel: AddMateViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: AddMateViewModel.Input!
    private var output: AddMateViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = AddMateViewModel(
            coordinator: nil,
            mateUseCase: MockMateUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel.requestMate(to: "materunner")
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_search_text_event() {
        let searchbarTextEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, "mate")
        ])
        let searchbarButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let loadTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = AddMateViewModel.Input(
            searchButtonDidTap: searchbarButtonEventTestableObservable.asObservable(),
            searchBarTextEvent: searchbarTextEventTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .loadData
            .subscribe(loadTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(loadTestableObservable.events, [
            .next(10, true)
        ])
    }
}
