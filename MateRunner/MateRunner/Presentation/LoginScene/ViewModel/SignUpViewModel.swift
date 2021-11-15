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
    }
    
    struct Output {
        @BehaviorRelayProperty var heightFieldText: String = "170 cm"
        @BehaviorRelayProperty var heightRange: [String] = [Int](100...250).map { "\($0) cm" }
        @BehaviorRelayProperty var heightPickerRow: Int = 70
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
        
        return output
    }
    
}
