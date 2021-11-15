//
//  SignUpViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/14.
//

import Foundation

import RxSwift

final class SignUpViewModel {
    private weak var coordinator: SignUpCoordinator?
    private let signUpUseCase: SignUpUseCase
    
    struct Input {
        let heightTextFieldDidTapEvent: Observable<Void>
        let heightPickerSelectedRow: Observable<Int>
        let weightTextFieldDidTapEvent: Observable<Void>
        let weightPickerSelectedRow: Observable<Int>
    }
    
    struct Output {
        @BehaviorRelayProperty var heightFieldText: String = "170 cm"
        @BehaviorRelayProperty var heightRange: [String] = [Int](100...250).map { "\($0) cm" }
        @BehaviorRelayProperty var heightPickerRow: Int = 70
        @BehaviorRelayProperty var weightFieldText: String = "60 kg"
        @BehaviorRelayProperty var weightRange: [String] = [Int](20...300).map { "\($0) kg" }
        @BehaviorRelayProperty var weightPickerRow: Int = 40
    }
    
    init(coordinator: SignUpCoordinator, signUpUseCase: SignUpUseCase) {
        self.coordinator = coordinator
        self.signUpUseCase = signUpUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.heightTextFieldDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.signUpUseCase.getCurrentHeight()
            })
            .disposed(by: disposeBag)
        
        input.heightPickerSelectedRow
            .map { $0 + 100 }
            .bind(to: self.signUpUseCase.height)
            .disposed(by: disposeBag)
        
        input.heightPickerSelectedRow
            .map { output.heightRange[$0] }
            .bind(to: output.$heightFieldText)
            .disposed(by: disposeBag)
        
        self.signUpUseCase.height
            .map { $0 - 100 }
            .bind(to: output.$heightPickerRow)
            .disposed(by: disposeBag)
        
        input.weightTextFieldDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.signUpUseCase.getCurrentWeight()
            })
            .disposed(by: disposeBag)
        
        input.weightPickerSelectedRow
            .map { $0 + 20 }
            .bind(to: self.signUpUseCase.weight)
            .disposed(by: disposeBag)
        
        input.weightPickerSelectedRow
            .map { output.weightRange[$0] }
            .bind(to: output.$weightFieldText)
            .disposed(by: disposeBag)
        
        self.signUpUseCase.weight
            .map { $0 - 20 }
            .bind(to: output.$weightPickerRow)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
