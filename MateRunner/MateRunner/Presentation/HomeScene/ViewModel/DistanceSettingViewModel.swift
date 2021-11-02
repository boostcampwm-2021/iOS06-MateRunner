//
//  DistanceSettingViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/01.
//

import Foundation
import RxCocoa
import RxSwift

final class DistanceSettingViewModel {
    private let distanceSettingUseCase = DistanceSettingUseCase()
    
    struct Input {
        let distance: Driver<String>
        let doneButtonTapEvent: Driver<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var distanceFieldText: String? = "5.00"
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.distance
            .map(self.configureLeadingZero)
            .map(self.distanceSettingUseCase.validate)
            .scan("") { oldValue, newValue in
                newValue == nil ? oldValue : newValue
            }
            .drive(output.$distanceFieldText)
            .disposed(by: disposeBag)
        
        input.doneButtonTapEvent
            .withLatestFrom(input.distance)
            .map(self.padZeros)
            .drive(output.$distanceFieldText)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func configureLeadingZero(from text: String) -> String {
        guard !text.isEmpty else { return "0" }
        guard text.first == "0" && text.count == 2 else { return text }
        return "\(text.last ?? "0")"
    }
    
    private func padZeros(text: String) -> String {
        var paddedText = text
        if paddedText.isEmpty { paddedText = "0" }
        return paddedText.contains(".") ? self.addZeros(to: paddedText) : paddedText + ".00"
    }
    
    private func addZeros(to text: String) -> String {
        var paddedText = text
        while paddedText.components(separatedBy: ".")[1].count < 2 {
            paddedText.append("0")
        }
        return paddedText
    }
}
