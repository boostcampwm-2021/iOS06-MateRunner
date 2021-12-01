//
//  MypageUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이유진 on 2021/12/01.
//

import XCTest

import RxSwift
import RxTest

final class MypageUseCaseTests: XCTestCase {
    private var mypageUseCase: MyPageUseCase!
    private var userRepository: UserRepository!
    private var firestoreRepository: FirestoreRepository!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        self.mypageUseCase = DefaultMyPageUseCase(
            userRepository: MockUserRepository(),
            firestoreRepository: MockFirestoreRepository()
        )
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.mypageUseCase.logout()
        self.mypageUseCase = nil
        self.disposeBag = nil
    }
    
    func test_load_user_success() {
        self.mypageUseCase.loadUserInfo()
        self.mypageUseCase.imageURL
            .subscribe(
                onNext: { _ in
                    XCTAssert(true)
                },
                onError: { _ in
                    XCTAssert(false)
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func test_delete_userdata_success() {
        self.mypageUseCase.deleteUserData()
            .subscribe(
                onNext: { success in
                    success
                    ? XCTAssert(true)
                    : XCTAssert(false)
                },
                onError: { _ in
                    XCTAssert(false)
                }
            )
            .disposed(by: self.disposeBag)
    }
    
}
