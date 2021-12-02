//
//  ProfileEditViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class ProfileEditViewModelTests: XCTestCase {
    private var viewModel: ProfileEditViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: ProfileEditViewModel.Input!
    private var output: ProfileEditViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = ProfileEditViewModel(
            profileEditCoordinator: nil,
            profileEditUseCase: MockProfileEditUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_height_weight_load() {
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let heightTextFieldEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let heightPickerEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, 50)
        ])
        let weightTextFieldEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let weightPickerEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, 30)
        ])
        let doneButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, Data())
        ])
        
        let heightTestableObservable = self.scheduler.createObserver(String.self)
        let weightTestableObservable = self.scheduler.createObserver(String.self)
        let imageTestableObservable = self.scheduler.createObserver(String.self)
        
        self.input = ProfileEditViewModel.Input(
            viewDidLoadEvent: viewDidLoadTestableObservable.asObservable(),
            heightTextFieldDidTapEvent: heightTextFieldEventTestableObservable.asObservable(),
            heightPickerSelectedRow: heightPickerEventTestableObservable.asObservable(),
            weightTextFieldDidTapEvent: weightTextFieldEventTestableObservable.asObservable(),
            weightPickerSelectedRow: weightPickerEventTestableObservable.asObservable(),
            doneButtonDidTapEvent: doneButtonEventTestableObservable.asObservable().map { _ in Data() }
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .heightFieldText
            .skip(6)
            .subscribe(heightTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .weightFieldText
            .skip(6)
            .subscribe(weightTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .imageURL
            .skip(3)
            .subscribe(imageTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(heightTestableObservable.events, [
            .next(10, "150 cm")
        ])
        
        XCTAssertEqual(weightTestableObservable.events, [
            .next(10, "50 kg")
        ])
        
        XCTAssertEqual(imageTestableObservable.events, [
            .next(10, "materunner.png")
        ])
    }
    
    func test_height_weight_selection() {
        let viewDidLoadTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let heightTextFieldEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let heightPickerEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, 50)
        ])
        let weightTextFieldEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, ())
        ])
        let weightPickerEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, 30)
        ])
        let doneButtonEventTestableObservable = self.scheduler.createHotObservable([
            .next(10, Data())
        ])
        
        let heightRowTestableObservable = self.scheduler.createObserver(Int?.self)
        let weightRowTestableObservable = self.scheduler.createObserver(Int?.self)
       
        self.input = ProfileEditViewModel.Input(
            viewDidLoadEvent: viewDidLoadTestableObservable.asObservable(),
            heightTextFieldDidTapEvent: heightTextFieldEventTestableObservable.asObservable(),
            heightPickerSelectedRow: heightPickerEventTestableObservable.asObservable(),
            weightTextFieldDidTapEvent: weightTextFieldEventTestableObservable.asObservable(),
            weightPickerSelectedRow: weightPickerEventTestableObservable.asObservable(),
            doneButtonDidTapEvent: doneButtonEventTestableObservable.asObservable().map { _ in Data() }
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .heightPickerRow
            .subscribe(heightRowTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .weightPickerRow
            .subscribe(weightRowTestableObservable)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(heightRowTestableObservable.events, [
            .next(0, nil),
            .next(10, 60)
        ])
        
        XCTAssertEqual(weightRowTestableObservable.events, [
            .next(0, nil),
            .next(10, 30)
        ])
    }
}
