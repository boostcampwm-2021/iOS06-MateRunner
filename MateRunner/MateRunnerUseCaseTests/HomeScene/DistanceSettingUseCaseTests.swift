//
//  DistanceSettingUseCaseTests.swift
//  DistanceSettingUseCaseTests
//
//  Created by 전여훈 on 2021/11/04.
//

import XCTest

import RxSwift
import RxTest

class DistanceSettingUseCaseTests: XCTestCase {
    var useCase: DistanceSettingUseCase?
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        self.useCase = DefaultDistanceSettingUseCase()
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.useCase = nil
        self.disposeBag = nil
    }
    
    func test_two_decimal_dots_failure() {
        let testableObserver = self.scheduler.createObserver(String?.self)
        self.scheduler.createColdObservable([
            .next(10, ".1."),
            .next(20, "1.."),
            .next(30, "..1"),
            .next(40, "1..1"),
            .next(50, "1.1.1")
        ])
            .subscribe(onNext: { self.useCase?.validate(text: $0)})
            .disposed(by: self.disposeBag)
        
        self.useCase?.validatedText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, nil),
            .next(20, nil),
            .next(30, nil),
            .next(40, nil),
            .next(50, nil)
        ])
    }
    
    func test_decimal_dot_between_numbers_success() {
        let testableObserver = self.scheduler.createObserver(String?.self)
        self.scheduler.createColdObservable([
            .next(10, "1.1"),
            .next(20, "0.1"),
            .next(30, "1.0")
        ])
            .subscribe(onNext: { self.useCase?.validate(text: $0)})
            .disposed(by: self.disposeBag)
        
        self.useCase?.validatedText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "1.1"),
            .next(20, "0.1"),
            .next(30, "1.0")
        ])
    }
    
    func test_no_number_in_front_of_decomal_dot_two_behind_success() {
        let testableObserver = self.scheduler.createObserver(String?.self)
        self.scheduler.createColdObservable([
            .next(10, ".10"),
            .next(20, ".11")
        ])
            .subscribe(onNext: { self.useCase?.validate(text: $0)})
            .disposed(by: self.disposeBag)
        
        self.useCase?.validatedText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, ".10"),
            .next(20, ".11")
        ])
    }
    
    func test_over_two_numbers_after_decimal_dot_failure() {
        let testableObserver = self.scheduler.createObserver(String?.self)
        self.scheduler.createColdObservable([
            .next(10, ".123"),
            .next(20, ".0123")
        ])
            .subscribe(onNext: { self.useCase?.validate(text: $0)})
            .disposed(by: self.disposeBag)
        
        self.useCase?.validatedText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, nil),
            .next(20, nil)
        ])
    }
    
    func test_two_numbers_before_decimal_dot_success() {
        let testableObserver = self.scheduler.createObserver(String?.self)
        self.scheduler.createColdObservable([
            .next(10, "10."),
            .next(20, "12.3"),
            .next(20, "12.34")
        ])
            .subscribe(onNext: { self.useCase?.validate(text: $0)})
            .disposed(by: self.disposeBag)
        
        self.useCase?.validatedText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, "10."),
            .next(20, "12.3"),
            .next(20, "12.34")
        ])
    }
    
    func test_three_sequential_numbers_failure() {
        let testableObserver = self.scheduler.createObserver(String?.self)
        self.scheduler.createColdObservable([
            .next(10, "100"),
            .next(20, "1234"),
            .next(20, "12345")
        ])
            .subscribe(onNext: { self.useCase?.validate(text: $0)})
            .disposed(by: self.disposeBag)
        
        self.useCase?.validatedText
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events, [
            .next(0, "5.00"),
            .next(10, nil),
            .next(20, nil),
            .next(20, nil)
        ])
    }
}
