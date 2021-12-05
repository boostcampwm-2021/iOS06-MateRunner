//
//  MateUseCaseTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/11/30.
//

import XCTest

import RxSwift
import RxTest

class MateUseCaseTests: XCTestCase {
    typealias MateList = [(key: String, value: String)]
    private var mateUseCase: MateUseCase!
    private var disposeBag: DisposeBag!
    private var mateRepository: MateRepository!
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        self.mateUseCase = DefaultMateUseCase(
            mateRepository: MockMateRepository(),
            firestoreRepository: MockFirestoreRepository(),
            userRepository: MockUserRepository()
        )
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.mateUseCase = nil
        self.disposeBag = nil
    }
    
    func test_nickname_filter_success() {
        let testableObserver = self.scheduler.createObserver(MateList.self)
        self.scheduler.createColdObservable([
            .next(10, [
                (key: "materunner", value: "image"),
                (key: "abc", value: "image"),
                (key: "boost", value: "image"),
                (key: "iOS", value: "image")
            ])
        ])
            .subscribe(onNext: { self.mateUseCase.filterMate(base: $0, from: "m")})
            .disposed(by: self.disposeBag)
        
        self.mateUseCase.mateList
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        let compare = MateList(arrayLiteral: (key: "materunner", value: "image"))
        testableObserver.events.forEach { result in
            for index in 0..<result.value.element!.count where !(result.value.element![index] == compare[index]) {
                XCTAssert(false)
            }
        }
        XCTAssert(true)
    }
    
    func test_uppercase_lowercase_filter_success() {
        let testableObserver = self.scheduler.createObserver(MateList.self)
        self.scheduler.createColdObservable([
            .next(10, [
                (key: "materunner", value: "image"),
                (key: "Materunner", value: "image"),
                (key: "Minji", value: "image"),
                (key: "mate", value: "image")
            ])
        ])
            .subscribe(onNext: { self.mateUseCase.filterMate(base: $0, from: "M")})
            .disposed(by: self.disposeBag)
        
        self.mateUseCase.mateList
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        let compare = MateList(arrayLiteral: (key: "Materunner", value: "image"), (key: "Minji", value: "image"))
        testableObserver.events.forEach { result in
            for index in 0..<result.value.element!.count where !(result.value.element![index] == compare[index]) {
                XCTAssert(false)
            }
        }
        XCTAssert(true)
    }
    
    func test_number_filter_success() {
        let testableObserver = self.scheduler.createObserver(MateList.self)
        self.scheduler.createColdObservable([
            .next(10, [
                (key: "123hun", value: "image"),
                (key: "33mateRunner", value: "image"),
                (key: "101minji", value: "image"),
                (key: "49mate", value: "image")
            ])
        ])
            .subscribe(onNext: { self.mateUseCase.filterMate(base: $0, from: "1")})
            .disposed(by: self.disposeBag)
        
        self.mateUseCase.mateList
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        let compare = MateList(arrayLiteral: (key: "123hun", value: "image"), (key: "101minji", value: "image"))
        testableObserver.events.forEach { result in
            for index in 0..<result.value.element!.count where !(result.value.element![index] == compare[index]) {
                XCTAssert(false)
            }
        }
        XCTAssert(true)
    }
    
    func test_sort_MateList_success() {
        self.mateUseCase.fetchMateImage(from: ["yujin", "minji", "jasonios"])
        let testableObserver = self.scheduler.createObserver(MateList.self)
        self.scheduler.createColdObservable([
            .next(10, ["yujin", "minji", "jasonios"])
        ])
            .subscribe(onNext: { self.mateUseCase.fetchMateImage(from: $0)})
            .disposed(by: self.disposeBag)
        
        self.mateUseCase.mateList
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        let compare = MateList(arrayLiteral:
                                (key: "jasonios", value: "https://firebasestorage.googleapis.com/profile"),
                               (key: "minji", value: "https://firebasestorage.googleapis.com/profile"),
                               (key: "yujin", value: "https://firebasestorage.googleapis.com/profile")
        )
        testableObserver.events.forEach { result in
            for index in 0..<result.value.element!.count where !(result.value.element![index] == compare[index]) {
                XCTAssert(false)
            }
        }
        XCTAssert(true)
    }
    
    func test_sort_MateList_failure() {
        self.mateUseCase.fetchMateImage(from: [])
        let testableObserver = self.scheduler.createObserver(MateList.self)
        self.scheduler.createColdObservable([
            .next(10, [])
        ])
            .subscribe(onNext: { self.mateUseCase.fetchMateImage(from: $0)})
            .disposed(by: self.disposeBag)
        
        self.mateUseCase.mateList
            .subscribe(testableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        testableObserver.events.forEach { result in
            if result.value.element!.count == 0 { XCTAssert(true) }
        }
    }
    
    func fetch_mate_image_success() {
        self.mateUseCase.fetchMateImage(from: ["yujin", "minji", "jasonios"])
        self.mateUseCase.didLoadMate
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
    
    func test_fetch_MateList_success() {
        self.mateUseCase.fetchMateList()
        self.mateUseCase.didLoadMate
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
    
    func test_fetch_searched_user_success() {
        self.mateUseCase.fetchSearchedUser(with: "y")
        self.mateUseCase.didLoadMate
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
    
    func test_request_mate_success() {
        self.mateUseCase.sendRequestMate(to: "yujin")
        self.mateUseCase.didLoadMate
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
