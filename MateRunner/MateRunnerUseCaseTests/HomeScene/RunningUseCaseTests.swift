//
//  RunningUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/02.
//

import CoreLocation
import XCTest

import RxSwift
import RxTest

final class RunningUseCaseTests: XCTestCase {
    private var useCase: DefaultRunningUseCase!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        var runningSetting = RunningSetting()
        runningSetting.targetDistance = 0
        runningSetting.mode = .single
        self.useCase = DefaultRunningUseCase(
            runningSetting: runningSetting,
            cancelTimer: MockTimerService(),
            runningTimer: MockTimerService(),
            popUpTimer: MockTimerService(),
            coreMotionService: MockCoreMotionService(),
            runningRepository: MockRunningRepository(),
            userRepository: MockUserRepository(),
            firestoreRepository: MockFirestoreRepository()
        )
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.useCase.updateRunningStatus()
    }
    
    override func tearDownWithError() throws {
        self.useCase.cancelRunningStatus()
        self.disposeBag = nil
    }
    
    func test_load_user_info_image_url() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.loadUserInfo() })
            .disposed(by: self.disposeBag)
        
        let imageURLTestableObserver = self.scheduler.createObserver(String.self)
        
        self.useCase.selfImageURL
            .subscribe(imageURLTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(imageURLTestableObserver.events, [ .next(10, "https://firebasestorage.googleapis.com/profile") ])
    }
    
    func test_load_user_info_weight() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.loadUserInfo() })
            .disposed(by: self.disposeBag)
        
        let weightTestableObserver = self.scheduler.createObserver(Double.self)
        
        self.useCase.selfWeight.skip(1)
            .subscribe(weightTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(weightTestableObserver.events, [ .next(10, 60) ])
    }
    
    func test_load_mate_info_mate_image_url() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.loadMateInfo() })
            .disposed(by: self.disposeBag)
        
        let imageURLTestableObserver = self.scheduler.createObserver(String.self)
        self.useCase.runningSetting.mateNickname = "materunner"
        self.useCase.mateImageURL
            .subscribe(imageURLTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(imageURLTestableObserver.events, [ .next(10, "https://firebasestorage.googleapis.com/profile") ])
    }
    
    func test_load_mate_info_mate_fail() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.loadMateInfo() })
            .disposed(by: self.disposeBag)
        
        let imageURLTestableObserver = self.scheduler.createObserver(String.self)
        self.useCase.runningSetting.mateNickname = nil
        self.useCase.mateImageURL
            .subscribe(imageURLTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(imageURLTestableObserver.events, [])
    }
    
    func test_start_pedometer_distance_1() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.executePedometer() })
            .disposed(by: self.disposeBag)
        
        let distanceTestableObserver = self.scheduler.createObserver(Double.self)
        
        self.useCase.runningData.skip(1).map({ $0.myElapsedDistance })
            .subscribe(distanceTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(distanceTestableObserver.events, [ .next(10, 0.001) ])
    }
    
    func test_start_pedometer_fail() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.executePedometer()})
            .disposed(by: self.disposeBag)
        
        let distanceTestableObserver = self.scheduler.createObserver(Double.self)
        self.useCase.runningSetting.targetDistance = nil
        self.useCase.runningData.skip(1).map({ $0.myElapsedDistance })
            .subscribe(distanceTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(distanceTestableObserver.events, [ .next(10, 0.001) ])
    }
    
    func test_execute_activity_expect_met_1() {
        useCase.executeActivity()
        XCTAssertEqual(self.useCase.currentMETs, 1)
    }
    
    func test_execute_timer_time_increase_five() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.executeTimer() })
            .disposed(by: self.disposeBag)
        
        let timeTestableObserver = self.scheduler.createObserver(Int.self)
        self.useCase.runningData.skip(1).map({ $0.myElapsedTime }).distinctUntilChanged()
            .subscribe(timeTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(timeTestableObserver.events, [
            .next(10, 1), .next(10, 2), .next(10, 3), .next(10, 4), .next(10, 5)
        ])
    }
    
    func test_execute_cancel_timer_decrease_five() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.executeCancelTimer()})
            .disposed(by: self.disposeBag)
        
        let timeTestableObserver = self.scheduler.createObserver(Int.self)
        self.useCase.cancelTimeLeft.distinctUntilChanged()
            .subscribe(timeTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(timeTestableObserver.events, [
            .next(10, 2), .next(10, 1), .next(10, 0),
            .next(10, -1), .next(10, -2), .next(10, -3)
        ])
    }
    
    func test_execute_cancel_timer_should_show_pop_up() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.executeCancelTimer() })
            .disposed(by: self.disposeBag)
        
        let boolTestableObserver = self.scheduler.createObserver(Bool.self)
        self.useCase.shouldShowPopUp
            .subscribe(boolTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(boolTestableObserver.events, [
            .next(0, false),
            .next(10, true),
            .next(10, true),
            .next(10, true),
            .next(10, true),
            .next(10, true),
            .next(10, true)
        ])
    }
    
    func test_execute_pop_up_timer_should_show_pop_up() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.executePopUpTimer() })
            .disposed(by: self.disposeBag)
        
        let boolTestableObserver = self.scheduler.createObserver(Bool.self)
        self.useCase.shouldShowPopUp.take(3)
            .subscribe(boolTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(boolTestableObserver.events, [
            .next(0, false), .next(10, true), .next(10, true), .completed(10)
        ])
    }
    
    func test_invalid_cancel_timer() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.invalidateCancelTimer() })
            .disposed(by: self.disposeBag)
        
        let numberTestableObserver = self.scheduler.createObserver(Int.self)
        self.useCase.cancelTimeLeft
            .subscribe(numberTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(numberTestableObserver.events, [ .next(10, 3) ])
    }
    
    func test_listen_running_session() {
        self.useCase.runningSetting.mateNickname = "materunner"
        self.useCase.runningSetting.sessionId = ""
        
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.listenRunningSession() })
            .disposed(by: self.disposeBag)
        
        let numberTestableObserver = self.scheduler.createObserver(Double.self)
        self.useCase.runningData.map({ $0.mateElapsedDistance })
            .subscribe(numberTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(numberTestableObserver.events, [ .next(0, 0), .next(10, 1) ])
    }
    
    func test_listen_running_session_no_mate_failure() {
        self.scheduler.createHotObservable([ .next(10, ()) ])
            .subscribe(onNext: { [weak self] in self?.useCase.listenRunningSession() })
            .disposed(by: self.disposeBag)
        
        let numberTestableObserver = self.scheduler.createObserver(Double.self)
        self.useCase.runningData.map({ $0.mateElapsedDistance })
            .subscribe(numberTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(numberTestableObserver.events, [ .next(0, 0) ])
    }
    
    func test_create_running_result_not_canceled_error() {
        self.useCase.runningSetting.sessionId = "test"
        self.useCase.runningSetting.mode = nil
        let result = self.useCase.createRunningResult(isCanceled: false)
        
        XCTAssertEqual(result, RunningResult(
            userNickname: "error",
            runningSetting: self.useCase.runningSetting,
            userElapsedDistance: 0,
            userElapsedTime: 0,
            calorie: 0,
            points: [],
            emojis: nil,
            isCanceled: false
        ))
    }
    
    func test_create_running_result_not_canceled_success() {
        self.useCase.runningSetting.sessionId = "test"
        self.useCase.runningSetting.mode = .single
        let result = self.useCase.createRunningResult(isCanceled: false)
        
        XCTAssertEqual(result, RunningResult(
            userNickname: "materunner",
            runningSetting: self.useCase.runningSetting,
            userElapsedDistance: 0,
            userElapsedTime: 0,
            calorie: 0,
            points: [],
            emojis: nil,
            isCanceled: false
        ))
    }
    
    func test_location_update() {
        self.useCase.locationDidUpdate(CLLocation(latitude: 1, longitude: 1))
        XCTAssertEqual(self.useCase.points, [Point(latitude: 1, longitude: 1)])
    }
}
