//
//  RunningModeSettingViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/02.
//

import Foundation

import RxSwift

final class RunningModeSettingViewModel {
    struct Input {
        let singleButtonTapEvent: Observable<Void>
        let mateButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var runningMode: RunningMode?
    }
    
    let runningSettingUseCase: DefaultRunningSettingUseCase
    
    init(runningSettingUseCase: DefaultRunningSettingUseCase) {
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.singleButtonTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.updateMode(mode: .single)
            })
            .disposed(by: disposeBag)
        
        input.mateButtonTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.updateMode(mode: .race)
            })
            .disposed(by: disposeBag)
        
        self.runningSettingUseCase.runningSetting
            .map(self.checkRunningMode)
            .bind(to: output.$runningMode)
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Private Functions

private extension RunningModeSettingViewModel {
    func checkRunningMode(running: RunningSetting) -> RunningMode? {
        return running.mode ?? nil
    }
}
