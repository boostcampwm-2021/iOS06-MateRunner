//
//  ProfileUseCaseTests.swift
//  MateRunnerUseCaseTests
//
//  Created by 이유진 on 2021/12/01.
//

import XCTest

import RxSwift
import RxTest

class ProfileUseCaseTests: XCTestCase {
    private var profileUseCase: ProfileUseCase!
    private var userRepository: UserRepository!
    private var firestoreRepository: FirestoreRepository!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        self.profileUseCase = DefaultProfileUseCase(
            userRepository: MockUserRepository(),
            firestoreRepository: MockFirestoreRepository()
        )
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.profileUseCase = nil
        self.disposeBag = nil
    }
    
    func test_fetch_user_info_success() {
        self.profileUseCase.fetchUserInfo("yujin")
        self.profileUseCase.userInfo
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
    
    func test_fetch_user_info_zero_count() {
        let testableObserver = self.scheduler.createObserver([RunningResult].self)
        self.scheduler.createColdObservable([
            .next(10, [])
        ])
            .subscribe(onNext: { list in
                testableObserver.onNext(list)
            })
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        self.profileUseCase.recordInfo
            .subscribe(
                onNext: { list in
                    XCTAssertEqual(list, [])
                },
                onError: { _ in
                    XCTAssert(false)
                })
            .disposed(by: self.disposeBag)
    }
    
    func test_fetch_record_all_list_success() {
        self.profileUseCase.fetchRecordList(nickname: "materunner", from: 0, by: 3)
        self.profileUseCase.recordInfo
            .subscribe(
                onNext: { list in
                    XCTAssertEqual(list, [
                        RunningResult(
                            runningSetting: RunningSetting(
                                sessionId: "session-yujin-20211130105106",
                                mode: .race,
                                targetDistance: 5.00,
                                hostNickname: "yujin",
                                mateNickname: "Minji",
                                dateTime: Date().startOfMonth
                            ), userNickname: "yujin"
                        ),
                        RunningResult(
                            runningSetting: RunningSetting(
                                sessionId: "session-hunhun-20211130105106",
                                mode: .team,
                                targetDistance: 3.00,
                                hostNickname: "hunhun",
                                mateNickname: "Jungwon",
                                dateTime: Date().startOfMonth
                            ), userNickname: "hunhun"
                        ),
                        RunningResult(
                            runningSetting: RunningSetting(
                                sessionId: "session-Minji-20211130105106",
                                mode: .team,
                                targetDistance: 3.00,
                                hostNickname: "Minji",
                                mateNickname: "hunhun",
                                dateTime: Date().startOfMonth
                            ), userNickname: "Minji"
                        )
                    ])
                },
                onError: { _ in
                    XCTAssert(false)
                })
            .disposed(by: self.disposeBag)
    }
    
    func test_fetch_record_page_one_success() {
        self.profileUseCase.fetchRecordList(nickname: "materunner", from: 0, by: 2)
        self.profileUseCase.recordInfo
            .subscribe(
                onNext: { list in
                    XCTAssertEqual(list, [
                        RunningResult(
                            runningSetting: RunningSetting(
                                sessionId: "session-yujin-20211130105106",
                                mode: .race,
                                targetDistance: 5.00,
                                hostNickname: "yujin",
                                mateNickname: "Minji",
                                dateTime: Date().startOfMonth
                            ), userNickname: "yujin"
                        ),
                        RunningResult(
                            runningSetting: RunningSetting(
                                sessionId: "session-hunhun-20211130105106",
                                mode: .team,
                                targetDistance: 3.00,
                                hostNickname: "hunhun",
                                mateNickname: "Jungwon",
                                dateTime: Date().startOfMonth
                            ), userNickname: "hunhun"
                        )
                    ])
                },
                onError: { _ in
                    XCTAssert(false)
                })
            .disposed(by: self.disposeBag)
    }
    
    func test_fetch_record_last_page_success() {
        self.profileUseCase.fetchRecordList(nickname: "materunner", from: 3, by: 5)
        self.profileUseCase.recordInfo
            .subscribe(
                onNext: { list in
                    XCTAssertEqual(list, [
                        RunningResult(
                            runningSetting: RunningSetting(
                                sessionId: "session-hunhun-20211130105106",
                                mode: .team,
                                targetDistance: 3.00,
                                hostNickname: "hunhun",
                                mateNickname: "Jungwon",
                                dateTime: Date().startOfMonth
                            ), userNickname: "hunhun"
                        )
                    ])
                },
                onError: { _ in
                    XCTAssert(false)
                })
            .disposed(by: self.disposeBag)
    }
    
    func test_fetch_user_nickname_success() {
        let nickname = self.profileUseCase.fetchUserNickname()
        XCTAssertEqual("materunner", nickname)
    }
    
    func test_emoji_did_select_success() {
        self.profileUseCase.emojiDidSelect(selectedEmoji: .clap)
        self.profileUseCase.selectEmoji
            .subscribe(
                onNext: { emoji in
                    XCTAssertEqual(emoji, .clap)
                },
                onError: { _ in
                    XCTAssert(false)
                })
            .disposed(by: self.disposeBag)
    }
    
    func test_delete_emoji_success() {
        self.profileUseCase.deleteEmoji(from: "running-id", of: "mate")
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
}
