////
////  DistanceSettingUseCaseTests.swift
////  DistanceSettingUseCaseTests
////
////  Created by 전여훈 on 2021/11/04.
////
//
// import XCTest
//
// import RxSwift
// import RxTest
//
// class DistanceSettingUseCaseTests: XCTestCase {
//	var useCase: DistanceSettingUseCase?
//	var disposeBag: DisposeBag!
//	var scheduler: TestScheduler!
//    override func setUpWithError() throws {
//		self.useCase = DefaultDistanceSettingUseCase()
//		self.scheduler = TestScheduler(initialClock: 0)
//		self.disposeBag = DisposeBag()
//    }
//
//    override func tearDownWithError() throws {
//		self.useCase = nil
//		self.disposeBag = nil
//    }
//	
//	func test_소수점_2개이상_실패() {
//		let testableObserver = self.scheduler.createObserver(String?.self)
//		self.scheduler.createColdObservable([
//			.next(10, ".1."),
//			.next(20, "1.."),
//			.next(30, "..1"),
//			.next(40, "1..1"),
//			.next(50, "1.1.1")
//		])
//			.subscribe(onNext: { self.useCase?.validate(text: $0)})
//			.disposed(by: self.disposeBag)
//
//		self.useCase?.validatedText
//			.subscribe(testableObserver)
//			.disposed(by: self.disposeBag)
//		
//		self.scheduler.start()
//		
//		XCTAssertEqual(testableObserver.events, [
//			.next(0, "5.00"),
//			.next(10, nil),
//			.next(20, nil),
//			.next(30, nil),
//			.next(40, nil),
//			.next(50, nil)
//		])
//	}
//	
//	func test_소수점_1개_소수점기준_앞뒤_문자하나_성공() {
//		let testableObserver = self.scheduler.createObserver(String?.self)
//		self.scheduler.createColdObservable([
//			.next(10, "1.1"),
//			.next(20, "0.1"),
//			.next(30, "1.0")
//		])
//			.subscribe(onNext: { self.useCase?.validate(text: $0)})
//			.disposed(by: self.disposeBag)
//		
//		self.useCase?.validatedText
//			.subscribe(testableObserver)
//			.disposed(by: self.disposeBag)
//		
//		self.scheduler.start()
//		
//		XCTAssertEqual(testableObserver.events, [
//			.next(0, "5.00"),
//			.next(10, "1.1"),
//			.next(20, "0.1"),
//			.next(30, "1.0")
//		])
//	}
//	
//	func test_소수점_1개_소수점기준_앞문자하나_뒤문자두개_성공() {
//		let testableObserver = self.scheduler.createObserver(String?.self)
//		self.scheduler.createColdObservable([
//			.next(10, ".10"),
//			.next(20, ".11")
//		])
//			.subscribe(onNext: { self.useCase?.validate(text: $0)})
//			.disposed(by: self.disposeBag)
//		
//		self.useCase?.validatedText
//			.subscribe(testableObserver)
//			.disposed(by: self.disposeBag)
//		
//		self.scheduler.start()
//		
//		XCTAssertEqual(testableObserver.events, [
//			.next(0, "5.00"),
//			.next(10, ".10"),
//			.next(20, ".11")
//		])
//	}
//	
//	func test_소수점_1개_소수점기준_앞문자하나_뒤문자두개초과_실패() {
//		let testableObserver = self.scheduler.createObserver(String?.self)
//		self.scheduler.createColdObservable([
//			.next(10, ".123"),
//			.next(20, ".0123")
//		])
//			.subscribe(onNext: { self.useCase?.validate(text: $0)})
//			.disposed(by: self.disposeBag)
//		
//		self.useCase?.validatedText
//			.subscribe(testableObserver)
//			.disposed(by: self.disposeBag)
//		
//		self.scheduler.start()
//		
//		XCTAssertEqual(testableObserver.events, [
//			.next(0, "5.00"),
//			.next(10, nil),
//			.next(20, nil)
//		])
//	}
//	
//	func test_소수점_1개_소수점기준_앞문자두개_성공() {
//		let testableObserver = self.scheduler.createObserver(String?.self)
//		self.scheduler.createColdObservable([
//			.next(10, "10."),
//			.next(20, "12.3"),
//			.next(20, "12.34")
//		])
//			.subscribe(onNext: { self.useCase?.validate(text: $0)})
//			.disposed(by: self.disposeBag)
//		
//		self.useCase?.validatedText
//			.subscribe(testableObserver)
//			.disposed(by: self.disposeBag)
//		
//		self.scheduler.start()
//		
//		XCTAssertEqual(testableObserver.events, [
//			.next(0, "5.00"),
//			.next(10, "10."),
//			.next(20, "12.3"),
//			.next(20, "12.34")
//		])
//	}
//	
//	func test_소수점_없이_3문자_이상입력_실패() {
//		let testableObserver = self.scheduler.createObserver(String?.self)
//		self.scheduler.createColdObservable([
//			.next(10, "100"),
//			.next(20, "1234"),
//			.next(20, "12345")
//		])
//			.subscribe(onNext: { self.useCase?.validate(text: $0)})
//			.disposed(by: self.disposeBag)
//		
//		self.useCase?.validatedText
//			.subscribe(testableObserver)
//			.disposed(by: self.disposeBag)
//		
//		self.scheduler.start()
//		
//		XCTAssertEqual(testableObserver.events, [
//			.next(0, "5.00"),
//			.next(10, nil),
//			.next(20, nil),
//			.next(20, nil)
//		])
//	}
// }
