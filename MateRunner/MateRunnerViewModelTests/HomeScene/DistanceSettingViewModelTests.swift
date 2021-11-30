//
//  DistanceSettingViewModelTests.swift
//  DistanceSettingTests
//
//  Created by 전여훈 on 2021/11/05.
//

 import XCTest

 import RxRelay
 import RxSwift
 import RxTest

 class DistanceSettingViewModelTests: XCTestCase {
	var viewModel: DistanceSettingViewModel!
	var disposeBag: DisposeBag!
	var scheduler: TestScheduler!
	var input: DistanceSettingViewModel.Input!
	var output: DistanceSettingViewModel.Output!
	
	override func setUpWithError() throws {
		self.viewModel = DistanceSettingViewModel(
            coordinator: nil,
            distanceSettingUseCase: MockDistanceSettingUseCase(),
            runningSettingUseCase: MockRunningSettingUseCase(
                runningSetting: RunningSetting(
                    sessionId: "",
                    mode: .single,
                    targetDistance: 0,
                    hostNickname: "",
                    mateNickname: "",
                    dateTime: Date()
                )
            )
		)
		self.disposeBag = DisposeBag()
		self.scheduler = TestScheduler(initialClock: 0)
	}
	
	override func tearDownWithError() throws {
		self.viewModel = nil
		self.disposeBag = nil
	}
	
	func test_설정버튼탭_소수점기호로_끝나면_0두개_붙이기() {
		let testableTextUpdateObservable = scheduler.createColdObservable([
			.next(10, "1."),
			.next(20, "12.")
		])
		let testableButtonTapObservable = scheduler.createColdObservable([
			.next(10, ()),
			.next(20, ())
		])
		let testableObserver = scheduler.createObserver(String.self)
        
		self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: testableButtonTapObservable.asObservable(),
            startButtonDidTapEvent: Observable.just(())
        )
        
		self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
			.distanceFieldText
			.subscribe(testableObserver)
			.disposed(by: self.disposeBag)
		
		self.scheduler.start()
		
		XCTAssertEqual(testableObserver.events, [
			.next(0, "5.00"),
			.next(10, "1."),
			.next(10, "1.00"),
			.next(20, "12."),
			.next(20, "12.00")
		])
	}
	
	func test_설정버튼탭_소수점기호_없으면_소수점_둘째짜리채워서_붙이기() {
		let testableTextUpdateObservable = scheduler.createColdObservable([
			.next(10, "1"),
			.next(20, "12")
		])
		let testableButtonTapObservable = scheduler.createColdObservable([
			.next(10, ()),
			.next(20, ())
		])
        
		let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: testableButtonTapObservable.asObservable(),
            startButtonDidTapEvent: Observable.just(())
        )
        
		self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
			.distanceFieldText
			.subscribe(testableObserver)
			.disposed(by: self.disposeBag)
		
		self.scheduler.start()
		
		XCTAssertEqual(testableObserver.events, [
			.next(0, "5.00"),
			.next(10, "1"),
			.next(10, "1.00"),
			.next(20, "12"),
			.next(20, "12.00")
		])
	}
	
	func test_설정버튼탭_0이면_기본값_5키로로_변경() {
		let testableTextUpdateObservable = scheduler.createColdObservable([
			.next(10, "0"),
			.next(20, "0.")
		])
		let testableButtonTapObservable = scheduler.createColdObservable([
			.next(10, ()),
			.next(20, ())
		])
		let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: testableButtonTapObservable.asObservable(),
            startButtonDidTapEvent: Observable.just(())
        )
        
		self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
			.distanceFieldText
			.subscribe(testableObserver)
			.disposed(by: self.disposeBag)
		
		self.scheduler.start()
		
		XCTAssertEqual(testableObserver.events, [
			.next(0, "5.00"),
			.next(10, "0"),
			.next(10, "5.00"),
			.next(20, "0."),
			.next(20, "5.00")
		])
	}
	
	func test_0으로_시작할때_입력_0지우고_숫자_채우기() {
		let testableTextUpdateObservable = scheduler.createColdObservable([
			.next(10, "01")
		])
		let testableObserver = scheduler.createObserver(String.self)
        
        self.input = DistanceSettingViewModel.Input(
            distance: testableTextUpdateObservable.asObservable(),
            doneButtonDidTapEvent: Observable.just(()),
            startButtonDidTapEvent: Observable.just(())
        )
        
		self.viewModel.transform(from: self.input, disposeBag: self.disposeBag)
			.distanceFieldText
			.subscribe(testableObserver)
			.disposed(by: self.disposeBag)
		
		self.scheduler.start()
		
		XCTAssertEqual(testableObserver.events, [
			.next(0, "5.00"),
			.next(10, "1")
		])
	}
	
 }
