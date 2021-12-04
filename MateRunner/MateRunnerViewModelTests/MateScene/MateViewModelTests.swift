//
//  MateViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/04.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class MateViewModelTests: XCTestCase {
    private var viewModel: MateViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: MateViewModel.Input!
    private var output: MateViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = MateViewModel(
            coordinator: nil,
            mateUseCase: MockMateUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel.pushMateProfile(of: "")
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_view_will_appear_search_button_event() {
        let viewWillAppearEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let searchBarTextEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, "mate")
        ])
        let navigationButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let searchButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let loadTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = MateViewModel.Input(
            viewWillAppearEvent: viewWillAppearEventTestableObservable.asObservable(),
            searchBarTextEvent: searchBarTextEventTestableObservable.asObservable(),
            navigationButtonDidTapEvent: navigationButtonEventTestableObservable.asObservable(),
            searchButtonDidTap: searchButtonEventTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .didLoadData
            .subscribe(loadTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(loadTestableObservable.events, [
            .next(10, true)
        ])
    }
    
    func test_search_text_event() {
        let viewWillAppearEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let searchBarTextEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, "mate"),
            .next(10, "mate"),
            .next(10, "mate")
        ])
        let navigationButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let searchButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let searachTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = MateViewModel.Input(
            viewWillAppearEvent: viewWillAppearEventTestableObservable.asObservable(),
            searchBarTextEvent: searchBarTextEventTestableObservable.asObservable(),
            navigationButtonDidTapEvent: navigationButtonEventTestableObservable.asObservable(),
            searchButtonDidTap: searchButtonEventTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .didFilterData
            .subscribe(searachTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(searachTestableObservable.events, [
            .next(10, true)
        ])
    }
}
