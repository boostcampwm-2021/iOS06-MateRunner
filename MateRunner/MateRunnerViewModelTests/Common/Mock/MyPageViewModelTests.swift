//
//  MyPageViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

class MyPageViewModelTests: XCTestCase {
    private var viewModel: MyPageViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: MyPageViewModel.Input!
    private var output: MyPageViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = MyPageViewModel(
            myPageCoordinator: nil,
            myPageUseCase: MockMyPageUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_user_info_load() {
        let viewWillAppearTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let notificationButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let profileEditButtonTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let licenseButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let imageTestableObservable = self.scheduler.createObserver(String.self)
        
        self.input = MyPageViewModel.Input(
            viewWillAppearEvent: viewWillAppearTestableObservable.asObservable(),
            notificationButtonDidTapEvent: notificationButtonEventTestableObservable.asObservable(),
            profileEditButtonDidTapEvent: profileEditButtonTestableObservable.asObservable(),
            licenseButtonDidTapEvent: licenseButtonEventTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .imageURL
            .subscribe(imageTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()

        XCTAssertEqual(imageTestableObservable.events, [
            .next(10, "materunner-profile.png")
        ])
    }

}
