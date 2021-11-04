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
	private let distanceSettingUseCase: DistanceSettingUseCase
    
    struct Input {
        let distance: Observable<String>
        let doneButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var distanceFieldText: String? = "5.00"
    }
	
	init(distanceSettingUseCase: DistanceSettingUseCase) {
		self.distanceSettingUseCase = distanceSettingUseCase
	}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.distance
			.subscribe(onNext: { self.distanceSettingUseCase.validate(text: $0) })
			.disposed(by: disposeBag)
        
        input.doneButtonTapEvent
            .withLatestFrom(input.distance)
            .map(self.padZeros)
			.map(self.convertInvalidDistance)
			.bind(to: output.$distanceFieldText)
            .disposed(by: disposeBag)
		
		self.distanceSettingUseCase.validatedText
			.scan("") { oldValue, newValue in
				newValue == nil ? oldValue : newValue
			}
			.map({ self.configureZeros(from: $0 ?? "0") })
			.bind(to: output.$distanceFieldText)
			.disposed(by: disposeBag)
        
        return output
    }
	
	private func convertInvalidDistance(from text: String) -> String {
		guard text != "0.00" else { return "5.00" }
		return text
	}
    
    private func configureZeros(from text: String) -> String {
        guard !text.isEmpty else { return "0" }
		guard !text.contains(".") && text.first == "0" else { return text }
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
