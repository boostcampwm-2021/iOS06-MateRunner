////
////  SingleRunningTests.swift
////  SingleRunningTests
////
////  Created by 전여훈 on 2021/11/06.
////
//
// import XCTest
//
// import RxRelay
// import RxSwift
// import RxTest
//
// class SingleRunningViewModelTests: XCTestCase {
//	var viewModel: SingleRunningViewModel!
//	var disposeBag: DisposeBag!
//	var scheduler: TestScheduler!
//	var input: SingleRunningViewModel.Input!
//	var output: SingleRunningViewModel.Output!
//	
//	override func setUpWithError() throws {
//		self.viewModel = SingleRunningViewModel(
//			runningUseCase: MockSingleRunningUseCase()
//		)
//		self.disposeBag = DisposeBag()
//		self.scheduler = TestScheduler.init(initialClock: 0)
//		
//	}
//	
//	override func tearDownWithError() throws {
//		self.viewModel = nil
//		self.disposeBag = nil
//	}
//	
//	func test_초_시분초텍스트_변환() {
//		let testableObserver = self.scheduler.createObserver(String.self)
//		let testableObservable = self.scheduler.createHotObservable([
//			.next(1, ()),
//			.next(10, ()),
//			.next(20, ()),
//			.next(30, ()),
//			.next(40, ()),
//			.next(50, ()),
//			.next(60, ()),
//			.next(70, ())
//		])
//		self.input = SingleRunningViewModel.Input(
//			viewDidLoadEvent: testableObservable.asObservable(),
//			finishButtonLongPressDidBeginEvent: Observable.just(()),
//			finishButtonLongPressDidCancelEvent: Observable.just(()),
//			finishButtonDidTapEvent: Observable.just(())
//		)
//		self.viewModel.transform(
//			from: self.input,
//			disposeBag: self.disposeBag
//		)
//			.$timeSpent
//			.subscribe(testableObserver)
//			.disposed(by: disposeBag)
//		
//		self.scheduler.start()
//		
//		XCTAssertEqual(testableObserver.events, [
//			.next(0, "00:00:00"),
//			.next(1, "00:00:01"),
//			.next(10, "00:00:10"),
//			.next(20, "00:00:30"),
//			.next(30, "00:01:00"),
//			.next(40, "00:01:30"),
//			.next(50, "00:10:00"),
//			.next(60, "01:00:00"),
//			.next(70, "01:10:10")
//		])
//	}
// }
