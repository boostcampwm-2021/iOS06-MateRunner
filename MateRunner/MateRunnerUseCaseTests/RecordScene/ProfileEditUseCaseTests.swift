//
//  ProfileEditUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이정원 on 2021/12/01.
//

import XCTest

import RxSwift
import RxTest

class ProfileEditUseCaseTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var firestoreRepository: FirestoreRepository!
    private var profileEditUseCase: ProfileEditUseCase!

    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.firestoreRepository = MockFirestoreRepository()
        self.profileEditUseCase = DefaultProfileEditUseCase(
            firestoreRepository: self.firestoreRepository,
            with: "MateRunner"
        )
    }

    override func tearDownWithError() throws {
        self.profileEditUseCase = nil
        self.firestoreRepository = nil
        self.disposeBag = nil
    }
    
    func test_load_user_info() {
        let heightOutput = scheduler.createObserver(Double?.self)
        let weightOutput = scheduler.createObserver(Double?.self)
        let imageURLOutput = scheduler.createObserver(String?.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.profileEditUseCase.loadUserInfo()
            })
            .disposed(by: self.disposeBag)
        
        self.profileEditUseCase.height
            .subscribe(heightOutput)
            .disposed(by: self.disposeBag)
        
        self.profileEditUseCase.weight
            .subscribe(weightOutput)
            .disposed(by: self.disposeBag)
        
        self.profileEditUseCase.imageURL
            .subscribe(imageURLOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(heightOutput.events, [
            .next(0, nil),
            .next(10, 170.0)
        ])
        
        XCTAssertEqual(weightOutput.events, [
            .next(0, nil),
            .next(10, 60.0)
        ])
        
        XCTAssertEqual(imageURLOutput.events, [
            .next(0, nil),
            .next(10, "https://firebasestorage.googleapis.com/profile")
        ])
    }
    
    func test_save_user_info() {
        let saveResultOutput = scheduler.createObserver(Bool.self)
        
        self.scheduler.createColdObservable([
            .next(10, ())
        ])
            .subscribe(onNext: { [weak self] in
                self?.profileEditUseCase.loadUserInfo()
                self?.profileEditUseCase.saveUserInfo(imageData: Data())
            })
            .disposed(by: self.disposeBag)
        
        self.profileEditUseCase.saveResult
            .debug()
            .subscribe(saveResultOutput)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(saveResultOutput.events, [
            .next(10, true)
        ])
    }
}
