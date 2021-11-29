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
        let nickname: Observable<String>
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
        var weightFieldText = BehaviorRelay<String>(value: "60 kg")
        var weightRange = BehaviorRelay<[String]>(value: Weight.range.map { "\($0) kg" })
        var weightPickerRow = BehaviorRelay<Int?>(value: nil)
        var nicknameFieldText = BehaviorRelay<String?>(value: "")
        var isNicknameValid = BehaviorRelay<Bool>(value: false)
        var canSignUp = BehaviorRelay<Bool>(value: true)
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
        input.nickname
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
    }
    
    private func createOutput(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let nickname = self.signUpUseCase.validText
            .scan("") { oldValue, newValue in
                newValue == nil ? oldValue: newValue
            }
        
        nickname.bind(to: output.nicknameFieldText)
            .disposed(by: disposeBag)
        
        nickname.map { ($0 ?? "").count >= 5 }
            .bind(to: output.isNicknameValid)
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
        
        self.bindSignUp(input: input, output: output, disposeBag: disposeBag)
        return output
    }
    
    private func bindSignUp(input: Input, output: Output, disposeBag: DisposeBag) {
        input.doneButtonDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.signUpUseCase.checkDuplicate(of: output.nicknameFieldText.value)
            })
            .disposed(by: disposeBag)
        
        self.signUpUseCase.canSignUp
            .bind(to: output.canSignUp)
            .disposed(by: disposeBag)
        
        self.signUpUseCase.canSignUp
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                let nickname = output.nicknameFieldText.value
                self?.signUpUseCase.signUp(nickname: nickname)
                self?.signUpUseCase.saveFCMToken(of: nickname)
            })
            .disposed(by: disposeBag)
        
        self.signUpUseCase.signUpResult
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.signUpUseCase.saveLoginInfo(nickname: output.nicknameFieldText.value)
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }
    
}
