//
//  SignUpViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/14.
//

import Foundation

import RxCocoa
import RxSwift

final class SignUpViewModel {
    private weak var coordinator: SignUpCoordinator?
    private let signUpUseCase: SignUpUseCase
    
    struct Input {
        let nicknameTextFieldDidEditEvent: Observable<String>
        let shuffleButtonDidTapEvent: Observable<Void>
        let heightTextFieldDidTapEvent: Observable<Void>
        let heightPickerSelectedRow: Observable<Int>
        let weightTextFieldDidTapEvent: Observable<Void>
        let weightPickerSelectedRow: Observable<Int>
        let doneButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var heightFieldText = BehaviorRelay<String>(value: "")
        var heightRange = BehaviorRelay<[String]>(value: Height.range.map { "\($0) cm" })
        var heightPickerRow = BehaviorRelay<Int?>(value: nil)
        var weightFieldText = BehaviorRelay<String>(value: "")
        var weightRange = BehaviorRelay<[String]>(value: Weight.range.map { "\($0) kg" })
        var weightPickerRow = BehaviorRelay<Int?>(value: nil)
        var nicknameFieldText = BehaviorRelay<String?>(value: "")
        var validationErrorMessage = BehaviorRelay<String?>(value: nil)
        var doneButtonShouldEnable = BehaviorRelay<Bool>(value: false)
        var profileEmoji = BehaviorRelay<String>(value: "👩🏻‍🚀")
    }
    
    init(coordinator: SignUpCoordinator, signUpUseCase: SignUpUseCase) {
        self.coordinator = coordinator
        self.signUpUseCase = signUpUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input, disposeBag: disposeBag)
        return createOutput(from: input, disposeBag: disposeBag)
    }
    
    private func configureInput(_ input: Input, disposeBag: DisposeBag) {
        input.nicknameTextFieldDidEditEvent
            .subscribe(onNext: { [weak self] nickname in
                self?.signUpUseCase.validate(text: nickname)
            })
            .disposed(by: disposeBag)
        
        input.heightPickerSelectedRow
            .map { Double(Height.range[$0]) }
            .bind(to: self.signUpUseCase.height)
            .disposed(by: disposeBag)
        
        input.weightPickerSelectedRow
            .map { Double(Weight.range[$0]) }
            .bind(to: self.signUpUseCase.weight)
            .disposed(by: disposeBag)
        
        input.shuffleButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.signUpUseCase.shuffleProfileEmoji()
            })
            .disposed(by: disposeBag)
    }
    
    private func createOutput(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.signUpUseCase.nicknameValidationState
            .subscribe(onNext: { state in
                output.nicknameFieldText.accept(self.signUpUseCase.nickname)
                output.validationErrorMessage.accept(self.createValidationErrorMessage(error: state))
                output.doneButtonShouldEnable.accept(state == .success)
            })
            .disposed(by: disposeBag)
        
        input.heightTextFieldDidTapEvent
            .withLatestFrom(self.signUpUseCase.height)
            .compactMap { $0 }
            .map { Height.toRow(from: $0) }
            .bind(to: output.heightPickerRow)
            .disposed(by: disposeBag)
        
        self.signUpUseCase.height
            .compactMap { $0 }
            .subscribe(onNext: { height in
                let row = Height.toRow(from: height)
                output.heightFieldText.accept(output.heightRange.value[row])
            })
            .disposed(by: disposeBag)
        
        input.weightTextFieldDidTapEvent
            .withLatestFrom(self.signUpUseCase.weight)
            .compactMap { $0 }
            .map { Weight.toRow(from: $0) }
            .bind(to: output.weightPickerRow)
            .disposed(by: disposeBag)
        
        self.signUpUseCase.weight
            .compactMap { $0 }
            .subscribe(onNext: { weight in
                let row = Weight.toRow(from: weight)
                output.weightFieldText.accept(output.weightRange.value[row])
            })
            .disposed(by: disposeBag)
        
        self.signUpUseCase.selectedProfileEmoji
            .bind(to: output.profileEmoji)
            .disposed(by: disposeBag)
        
        self.bindSignUp(from: input, with: output, disposeBag: disposeBag)
        
        return output
    }
    
    private func bindSignUp(from input: Input, with output: Output, disposeBag: DisposeBag) {
        input.doneButtonDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.signUpUseCase.signUp()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { _ in
                        self?.signUpUseCase.saveLoginInfo()
                        self?.coordinator?.finish()
                    }, onError: { error in
                        guard let error = error as? SignUpValidationError else { return }
                        output.validationErrorMessage.accept(self?.createSignUpErrorMessage(error: error))
                        output.doneButtonShouldEnable.accept(false)
                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)
    }
    
    private func createSignUpErrorMessage(error: SignUpValidationError) -> String {
        switch error {
        case .nicknameDuplicatedError:
            return "이미 존재하는 닉네임입니다"
        case .requiredDataMissingError:
            return "알 수 없는 에러"
        }
    }
    
    private func createValidationErrorMessage(error: SignUpValidationState) -> String {
        switch error {
        case .empty, .success:
            return ""
        case .lowerboundViolated:
            return "최소 5자 이상 입력해주세요"
        case .upperboundViolated:
            return "최대 20자까지만 가능해요"
        case .invalidLetterIncluded:
            return "영문과 숫자만 입력할 수 있어요"
        }
    }
    
}
