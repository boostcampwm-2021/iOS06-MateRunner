//
//  MateProfileViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/03.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class MateProfileViewModelTests: XCTestCase {
    private var viewModel: MateProfileViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: MateProfileViewModel.Input!
    private var output: MateProfileViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = MateProfileViewModel(
            nickname: "materunner",
            coordinator: nil,
            profileUseCase: MockProfileUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel.moveToEmoji(record: RunningResult(
            runningSetting: RunningSetting(),
            userNickname: "mate")
        )
        self.viewModel.moveToDetail(record: RunningResult(
            runningSetting: RunningSetting(),
            userNickname: "mate")
        )
        self.viewModel = nil
        self.disposeBag = nil
    }
   
    func test_mate_info_load_() {
        let viewDidLoadEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let refreshEventTestableObservable = self.scheduler.createHotObservable([
            .next(0, ())
        ])
        let scrollEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let profileTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = MateProfileViewModel.Input(
            viewDidLoadEvent: viewDidLoadEventTestableObservable.asObservable(),
            refreshEvent: refreshEventTestableObservable.asObservable(),
            scrollEvent: scrollEventTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .loadProfile
            .skip(1)
            .subscribe(profileTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(profileTestableObservable.events, [
            .next(10, true)
        ])
    }
    
    func test_record_info_load_() {
        let viewDidLoadEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let refreshEventTestableObservable = self.scheduler.createHotObservable([
            .next(0, ())
        ])
        let scrollEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        
        let recordTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = MateProfileViewModel.Input(
            viewDidLoadEvent: viewDidLoadEventTestableObservable.asObservable(),
            refreshEvent: refreshEventTestableObservable.asObservable(),
            scrollEvent: scrollEventTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .loadRecord
            .skip(2)
            .subscribe(recordTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(recordTestableObservable.events, [
            .next(10, true)
        ])
    }
    
    func test_refresh_event() {
        let viewDidLoadEventTestableObservable = self.scheduler.createHotObservable([
            .next(0, ())
        ])
        let refreshEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let scrollEventTestableObservable = self.scheduler.createHotObservable([
            .next(0, ())
        ])
        
        let reloadTestableObservable = self.scheduler.createObserver(Bool.self)
        
        self.input = MateProfileViewModel.Input(
            viewDidLoadEvent: viewDidLoadEventTestableObservable.asObservable(),
            refreshEvent: refreshEventTestableObservable.asObservable(),
            scrollEvent: scrollEventTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .reloadData
            .skip(3)
            .subscribe(reloadTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(reloadTestableObservable.events, [
            .next(10, true)
        ])
    }
    
    func test_fetch_user_nickname() {
        let nickname = self.viewModel.fetchUserNickname()
        XCTAssertEqual("applegarden", nickname)
    }
}
