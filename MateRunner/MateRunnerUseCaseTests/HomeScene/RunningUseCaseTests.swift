//
//  RunningUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/02.
//

import XCTest

import RxSwift
import RxTest

final class RunningUseCaseTests: XCTestCase {
    private var useCase: RunningUseCase!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        self.useCase = DefaultRunningUseCase(
            runningSetting: RunningSetting(),
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
        self.scheduler.createHotObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] in
            self?.useCase.loadUserInfo()
        }).disposed(by: self.disposeBag)
        
        let imageURLTestableObserver = self.scheduler.createObserver(String.self)
        
        self.useCase.selfImageURL
            .subscribe(imageURLTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(imageURLTestableObserver.events, [
            .next(10, "https://firebasestorage.googleapis.com/profile")
        ])
    }
    
    func test_load_user_info_weight() {
        self.scheduler.createHotObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] in
            self?.useCase.loadUserInfo()
        }).disposed(by: self.disposeBag)
        
        let weightTestableObserver = self.scheduler.createObserver(Double.self)
        
        self.useCase.selfWeight
            .skip(1)
            .subscribe(weightTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(weightTestableObserver.events, [
            .next(10, 60)
        ])
    }
    
    func test_load_mate_info_mate_image_url() {
        self.scheduler.createHotObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] in
            self?.useCase.loadMateInfo()
        }).disposed(by: disposeBag)
        
        let imageURLTestableObserver = self.scheduler.createObserver(String.self)
        self.useCase.runningSetting.mateNickname = "materunner"
        self.useCase.mateImageURL
            .subscribe(imageURLTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(imageURLTestableObserver.events, [
            .next(10, "https://firebasestorage.googleapis.com/profile")
        ])
    }
    
    func test_load_mate_info_mate_fail() {
        self.scheduler.createHotObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] in
            self?.useCase.loadMateInfo()
        }).disposed(by: disposeBag)
        
        let imageURLTestableObserver = self.scheduler.createObserver(String.self)
        self.useCase.runningSetting.mateNickname = nil
        self.useCase.mateImageURL
            .subscribe(imageURLTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(imageURLTestableObserver.events, [])
    }
    
    func test_start_pedometer_distance_1() {
        self.scheduler.createHotObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] in
            self?.useCase.executePedometer()
        }).disposed(by: self.disposeBag)
        
        let distanceTestableObserver = self.scheduler.createObserver(Double.self)
        
        self.useCase.runningData
            .skip(1)
            .map({ $0.myElapsedDistance })
            .subscribe(distanceTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(distanceTestableObserver.events, [
            .next(10, 0.001)
        ])
    }
    
    func test_start_pedometer_fail() {
        self.scheduler.createHotObservable([
            .next(10, ())
        ]).subscribe(onNext: { [weak self] in
            self?.useCase.executePedometer()
        }).disposed(by: self.disposeBag)
        
        let distanceTestableObserver = self.scheduler.createObserver(Double.self)
        self.useCase.runningSetting.targetDistance = nil
        self.useCase.runningData
            .skip(1)
            .map({ $0.myElapsedDistance })
            .subscribe(distanceTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(distanceTestableObserver.events, [
            .next(10, 0.001)
        ])
    }
    
    func test_execute_activity_expect_met_1() {
        useCase.executeActivity()
        XCTAssertEqual(self.useCase.currentMETs, 1)
    }
    
    func test_execute_timer_calorie() {
        
    }
}
