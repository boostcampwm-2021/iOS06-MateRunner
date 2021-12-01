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
    }
    
    func test_load_user_info() {
        // Sfesdfcxkl2131sd
    }
}
