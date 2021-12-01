//
//  MapViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/01.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class MapViewModelTests: XCTestCase {
    private var viewModel: MapViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: MapViewModel.Input!
    private var output: MapViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = MapViewModel(mapUseCase: MockMapUseCase())
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = DisposeBag()
    }
    
    func test_loacte_button_did_tap_trigger_should_set_center_true() {
        let viewDidAppearTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let backButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, ())
        ])
        let locateButtonTestableObservable = self.scheduler.createHotObservable([
            .next(40, ())
        ])
        let mapDidPanTestableObservable = self.scheduler.createHotObservable([
            .next(30, ())
        ])
        let testableObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = MapViewModel.Input(
            viewDidAppearEvent: viewDidAppearTestableObservable.asObservable(),
            locateButtonDidTapEvent: locateButtonTestableObservable.asObservable(),
            backButtonDidTapEvent: backButtonTestableObservable.asObservable(),
            mapDidPanEvent: mapDidPanTestableObservable.asObservable()
        )
        
        self.viewModel.transform(input: self.input, disposeBag: self.disposeBag)
            .shouldSetCenter
            .skip(3)
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(40, true)
        ])
    }
    
    func test_map_did_pan_trigger_should_set_center_false() {
        let viewDidAppearTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let backButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, ())
        ])
        let locateButtonTestableObservable = self.scheduler.createHotObservable([
            .next(30, ())
        ])
        let mapDidPanTestableObservable = self.scheduler.createHotObservable([
            .next(40, ())
        ])
        let testableObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = MapViewModel.Input(
            viewDidAppearEvent: viewDidAppearTestableObservable.asObservable(),
            locateButtonDidTapEvent: locateButtonTestableObservable.asObservable(),
            backButtonDidTapEvent: backButtonTestableObservable.asObservable(),
            mapDidPanEvent: mapDidPanTestableObservable.asObservable()
        )
        
        self.viewModel.transform(input: self.input, disposeBag: self.disposeBag)
            .shouldSetCenter
            .skip(3)
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(40, false)
        ])
    }
    
    func test_back_button_did_tap_trigger_should_move_first_page_true() {
        let viewDidAppearTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let backButtonTestableObservable = self.scheduler.createHotObservable([
            .next(40, ())
        ])
        let locateButtonTestableObservable = self.scheduler.createHotObservable([
            .next(20, ())
        ])
        let mapDidPanTestableObservable = self.scheduler.createHotObservable([
            .next(30, ())
        ])
        let testableObserver = self.scheduler.createObserver(Bool.self)
        
        self.input = MapViewModel.Input(
            viewDidAppearEvent: viewDidAppearTestableObservable.asObservable(),
            locateButtonDidTapEvent: locateButtonTestableObservable.asObservable(),
            backButtonDidTapEvent: backButtonTestableObservable.asObservable(),
            mapDidPanEvent: mapDidPanTestableObservable.asObservable()
        )
        
        self.viewModel.transform(input: self.input, disposeBag: self.disposeBag)
            .shouldMoveToFirstPage
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(40, true)
        ])
    }
}
