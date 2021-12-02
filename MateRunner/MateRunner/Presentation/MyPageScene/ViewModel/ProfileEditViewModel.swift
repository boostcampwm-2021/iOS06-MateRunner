//
//  ProfileEditViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxCocoa
import RxSwift

final class ProfileEditViewModel {
    private weak var coordinator: MyPageCoordinator?
    private let profileEditUseCase: ProfileEditUseCase
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let heightTextFieldDidTapEvent: Observable<Void>
        let heightPickerSelectedRow: Observable<Int>
        let weightTextFieldDidTapEvent: Observable<Void>
        let weightPickerSelectedRow: Observable<Int>
        let doneButtonDidTapEvent: Observable<Data?>
    }
    
    struct Output {
        var heightFieldText = BehaviorRelay<String>(value: "")
        var heightRange = BehaviorRelay<[String]>(value: Height.range.map { "\($0) cm" })
        var heightPickerRow = BehaviorRelay<Int?>(value: nil)
        var weightFieldText = BehaviorRelay<String>(value: "")
        var weightRange = BehaviorRelay<[String]>(value: Weight.range.map { "\($0) kg" })
        var weightPickerRow = BehaviorRelay<Int?>(value: nil)
        var nickname = BehaviorRelay<String>(value: "")
        var imageURL = BehaviorRelay<String>(value: "")
    }
    
    init(coordinator: MyPageCoordinator?, profileEditUseCase: ProfileEditUseCase) {
        self.coordinator = coordinator
        self.profileEditUseCase = profileEditUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input, disposeBag: disposeBag)
        return self.createOutput(from: input, disposeBag: disposeBag)
    }
    
    private func configureInput(_ input: Input, disposeBag: DisposeBag) {
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.profileEditUseCase.loadUserInfo()
            })
            .disposed(by: disposeBag)
        
        input.heightPickerSelectedRow
            .map { Double(Height.range[$0]) }
            .bind(to: self.profileEditUseCase.height)
            .disposed(by: disposeBag)
        
        input.weightPickerSelectedRow
            .map { Double(Weight.range[$0]) }
            .bind(to: self.profileEditUseCase.weight)
            .disposed(by: disposeBag)
        
        input.doneButtonDidTapEvent
            .subscribe(onNext: { [weak self] imageData in
                guard let imageData = imageData else { return }
                self?.profileEditUseCase.saveUserInfo(imageData: imageData)
            })
            .disposed(by: disposeBag)
        
        self.profileEditUseCase.saveResult
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.popViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func createOutput(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.just(self.profileEditUseCase.nickname)
            .compactMap { $0 }
            .bind(to: output.nickname)
            .disposed(by: disposeBag)
        
        input.heightTextFieldDidTapEvent
            .withLatestFrom(self.profileEditUseCase.height)
            .compactMap { $0 }
            .map { Height.toRow(from: $0) }
            .bind(to: output.heightPickerRow)
            .disposed(by: disposeBag)
        
        self.profileEditUseCase.height
            .compactMap { $0 }
            .subscribe(onNext: { height in
                let row = Height.toRow(from: height)
                output.heightFieldText.accept(output.heightRange.value[row])
            })
            .disposed(by: disposeBag)
        
        input.weightTextFieldDidTapEvent
            .withLatestFrom(self.profileEditUseCase.weight)
            .compactMap { $0 }
            .map { Weight.toRow(from: $0) }
            .bind(to: output.weightPickerRow)
            .disposed(by: disposeBag)
        
        self.profileEditUseCase.weight
            .compactMap { $0 }
            .subscribe(onNext: { weight in
                let row = Weight.toRow(from: weight)
                output.weightFieldText.accept(output.weightRange.value[row])
            })
            .disposed(by: disposeBag)
        
        self.profileEditUseCase.imageURL
            .compactMap { $0 }
            .bind(to: output.imageURL)
            .disposed(by: disposeBag)
        
        return output
    }
}
