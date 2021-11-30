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
    private let runningSettingUseCase: RunningSettingUseCase
    private weak var coordinator: RunningSettingCoordinator?
    
    struct Input {
        let distance: Observable<String>
        let doneButtonDidTapEvent: Observable<Void>
        let startButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var distanceFieldText = BehaviorRelay<String>(value: "5.00")
        let keyboardShouldhide = PublishRelay<Bool>()
    }
    
    init(
        coordinator: RunningSettingCoordinator?,
        distanceSettingUseCase: DistanceSettingUseCase,
        runningSettingUseCase: RunningSettingUseCase
    ) {
        self.coordinator = coordinator
        self.distanceSettingUseCase = distanceSettingUseCase
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.distance
            .subscribe(onNext: { [weak self] distance in
                self?.distanceSettingUseCase.validate(text: distance)
            })
            .disposed(by: disposeBag)
        
        input.doneButtonDidTapEvent
            .withLatestFrom(input.distance)
            .map(self.padZeros)
            .map(self.convertInvalidDistance)
            .bind(to: output.distanceFieldText)
            .disposed(by: disposeBag)
        
        input.doneButtonDidTapEvent
            .map {true}
            .bind(to: output.keyboardShouldhide)
            .disposed(by: disposeBag)
        
        input.startButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.updateDateTime(date: Date())
                
                self?.coordinator?.navigateProperViewController(
                    with: try? self?.runningSettingUseCase.runningSetting.value()
                )
            })
            .disposed(by: disposeBag)
        
        self.distanceSettingUseCase.validatedText
            .scan("") { oldValue, newValue in
                newValue == nil ? oldValue : newValue
            }
            .map({ self.configureZeros(from: $0 ?? "0") })
            .bind(to: output.distanceFieldText)
            .disposed(by: disposeBag)
        
        self.distanceSettingUseCase.validatedText
            .distinctUntilChanged()
            .compactMap(self.convertToDouble)
            .subscribe(onNext: { newDistance in
                self.runningSettingUseCase.updateTargetDistance(distance: newDistance)
                self.runningSettingUseCase.updateHostNickname()
                self.runningSettingUseCase.updateSessionId()
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func convertToDouble(from distance: String?) -> Double? {
        guard let distance = distance else { return nil }
        return Double(distance)
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
