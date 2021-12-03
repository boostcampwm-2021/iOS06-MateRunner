//
//  MapUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/02.
//

import XCTest

import RxSwift
import RxTest

final class MapUseCaseTests: XCTestCase {
    private var useCase: MapUseCase!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        self.useCase = DefaultMapUseCase(
            locationService: MockLocationService(),
            delegate: nil
        )
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.useCase.executeLocationTracker()
    }
    
    override func tearDownWithError() throws {
        self.useCase.terminateLocationTracker()
        self.useCase = nil
        self.disposeBag = nil
    }
    
    func test_request_location() {
        let testableObserver = self.scheduler.createObserver(Point.self)
        self.scheduler.createHotObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { self.useCase.requestLocation() })
            .disposed(by: self.disposeBag)
        
        self.useCase.updatedLocation
            .map({ Point(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) })
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events, [
            .next(10, Point(latitude: 1, longitude: 1))
        ])
    }
}
