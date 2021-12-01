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
    
    func test_loacte_button_did_tap_should_set_center_true() {
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
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(40, true)
        ])
    }
    
//    struct Input {
//        let viewDidAppearEvent: Observable<Void>
//        let locateButtonDidTapEvent: Observable<Void>
//        let backButtonDidTapEvent: Observable<Void>
//        let mapDidPanEvent: Observable<Void>
//    }
//
//    struct Output {
//        let shouldSetCenter: BehaviorRelay<Bool> = BehaviorRelay(value: true)
//        let shouldMoveToFirstPage: PublishRelay<Bool> = PublishRelay()
//        let coordinatesToDraw: PublishRelay<(CLLocationCoordinate2D, CLLocationCoordinate2D)> = PublishRelay()
//    }
}
