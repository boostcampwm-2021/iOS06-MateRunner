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
    
    struct Input {
        let heightTextFieldDidTapEvent: Observable<Void>
        let heightPickerSelectedRow: Observable<Int>
        let heightDoneButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var heightFieldText: String = "170 cm"
        @BehaviorRelayProperty var heightRange: [String] = [Int](100...250).map { "\($0) cm" }
        @BehaviorRelayProperty var heightPickerRow: Int = 70
    }
    
    init(coordinator: SignUpCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input.heightTextFieldDidTapEvent
        
        input.heightPickerSelectedRow
            .bind(to: output.$heightPickerRow)
            .disposed(by: disposeBag)
        
        input.heightDoneButtonDidTapEvent
            .map { "\(output.heightRange[output.heightPickerRow])" }
            .bind(to: output.$heightFieldText)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
