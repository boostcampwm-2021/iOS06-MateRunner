//
//  HomeUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/02.
//

import CoreLocation
import XCTest

import RxSwift
import RxTest

final class HomeUseCaseTests: XCTestCase {
    private var useCase: HomeUseCase!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var mockLocationService: MockLocationService!
    
    override func setUpWithError() throws {
        self.mockLocationService = MockLocationService()
        self.useCase = DefaultHomeUseCase(
            locationService: self.mockLocationService
        )
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.useCase.stopUpdatingLocation()
        self.useCase = nil
        self.disposeBag = nil
    }
    
    func test_location_authorization_not_determined() {
        let testableObserver = self.scheduler.createObserver(LocationAuthorizationStatus?.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] _ in
            self?.mockLocationService.authorizationStatus.accept(.notDetermined)
        }).disposed(by: self.disposeBag)
        
        self.useCase.checkAuthorization()
        self.useCase.authorizationStatus
            .skip(1)
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events, [
            .next(10, .notDetermined)
        ])
    }
    
    func test_location_authorization_authorizedAlways_expect_allow() {
        let testableObserver = self.scheduler.createObserver(LocationAuthorizationStatus?.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] _ in
            self?.mockLocationService.authorizationStatus.accept(.authorizedAlways)
        }).disposed(by: self.disposeBag)
        
        self.useCase.checkAuthorization()
        self.useCase.authorizationStatus
            .skip(1)
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events, [
            .next(10, .allowed)
        ])
    }
    
    func test_location_authorization_authorizedInUse_expect_allow() {
        let testableObserver = self.scheduler.createObserver(LocationAuthorizationStatus?.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] _ in
            self?.mockLocationService.authorizationStatus.accept(.authorizedWhenInUse)
        }).disposed(by: self.disposeBag)
        
        self.useCase.checkAuthorization()
        self.useCase.authorizationStatus
            .skip(1)
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events, [
            .next(10, .allowed)
        ])
    }
    
    func test_location_authorization_denied_expect_disallow() {
        let testableObserver = self.scheduler.createObserver(LocationAuthorizationStatus?.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] _ in
            self?.mockLocationService.authorizationStatus.accept(.denied)
        }).disposed(by: self.disposeBag)
        
        self.useCase.checkAuthorization()
        self.useCase.authorizationStatus
            .skip(1)
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events, [
            .next(10, .disallowed)
        ])
    }
    
    func test_location_authorization_restricted_expect_disallow() {
        let testableObserver = self.scheduler.createObserver(LocationAuthorizationStatus?.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] _ in
            self?.mockLocationService.authorizationStatus.accept(.restricted)
        }).disposed(by: self.disposeBag)
        
        self.useCase.checkAuthorization()
        self.useCase.authorizationStatus
            .skip(1)
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events, [
            .next(10, .disallowed)
        ])
    }
    
    func test_observation_user_location_expect_lat1_long1() {
        let testableObserver = self.scheduler.createObserver(Point.self)
        self.scheduler.createHotObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] in
            self?.useCase.observeUserLocation()
        }).disposed(by: self.disposeBag)
        
        self.useCase.userLocation
            .map({ Point(
                latitude: $0.coordinate.latitude,
                longitude: $0.coordinate.longitude)
            })
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(10, Point(latitude: 1, longitude: 1))
        ])
    }
}
