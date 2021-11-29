////
////  RunningPreparationViewModelTests.swift
////  RunningPreparationViewModelTests
////
////  Created by 전여훈 on 2021/11/03.
////
//
// import XCTest
//
// import RxCocoa
// import RxRelay
// import RxSwift
// import RxTest
//
// class RunningPreparationViewModelTests: XCTestCase {
//	var viewModel: RunningPreparationViewModel!
//	var disposeBag: DisposeBag!
//	var scheduler: TestScheduler!
//	var input: RunningPreparationViewModel.Input!
//	var output: RunningPreparationViewModel.Output!
//	
//    override func setUpWithError() throws {
//		self.viewModel = RunningPreparationViewModel(
//            runningPreparationUseCase: MockRunningPreparationUseCase()
//		)
//		self.disposeBag = DisposeBag()
//		self.scheduler = TestScheduler(initialClock: 0)
//		let testableObservable = scheduler.createColdObservable([.next(10, ())])
//		self.input = RunningPreparationViewModel.Input(viewDidLoadEvent: testableObservable.asObservable())
//		self.output = viewModel.transform(from: input, disposeBag: self.disposeBag)
//    }
//
//    override func tearDownWithError() throws {
//		self.viewModel = nil
//		self.disposeBag = DisposeBag()
//    }
//	
//	func test_viewDidLoad_이벤트_후_남은시간_텍스트로_방출() {
//		// observe output
//		let timeLeft = self.scheduler.createObserver(String?.self)
//		self.output.$timeLeft
//			.asDriver()
//			.drive(timeLeft)
//			.disposed(by: self.disposeBag)
//		
//		// begin
//		self.scheduler.start()
//		
//		// test
//		XCTAssertEqual(timeLeft.events, [
//			.next(0, "0"),
//			.next(10, "1"),
//			.next(10, "2"),
//			.next(10, "3")
//		])
//	}
//	
//	func test_남은시간_0일때_뷰이동_플래그_true() {
//		// observe output
//		let navigateToNext = self.scheduler.createObserver(Bool?.self)
//		self.output.$navigateToNext
//			.asDriver()
//			.drive(navigateToNext)
//			.disposed(by: self.disposeBag)
//		
//		// begin
//		self.scheduler.start()
//		
//		// test
//		XCTAssertEqual(navigateToNext.events, [
//			.next(0, false),
//			.next(10, true)
//		])
//	}
// }
