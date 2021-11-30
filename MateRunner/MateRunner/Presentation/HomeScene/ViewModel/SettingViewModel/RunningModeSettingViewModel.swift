//
//  RunningModeSettingViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/02.
//

import Foundation

import RxSwift
import RxRelay

final class RunningModeSettingViewModel {
    private weak var coordinator: RunningSettingCoordinator?
    private let runningSettingUseCase: RunningSettingUseCase
    
    struct Input {
        let singleButtonTapEvent: Observable<Void>
        let mateButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        var runningMode = PublishRelay<RunningMode>()
    }
    
    init(coordinator: RunningSettingCoordinator?, runningSettingUseCase: RunningSettingUseCase) {
        self.coordinator = coordinator
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.singleButtonTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.updateMode(mode: .single)
                self?.coordinator?.pushDistanceSettingViewController(
                    with: try? self?.runningSettingUseCase.runningSetting.value()
                )
            })
            .disposed(by: disposeBag)
        
        input.mateButtonTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.updateMode(mode: .race)
                self?.coordinator?.pushMateRunningModeSettingViewController(
                    with: try? self?.runningSettingUseCase.runningSetting.value()
                )
            })
            .disposed(by: disposeBag)
        
        self.runningSettingUseCase.runningSetting
            .compactMap({ $0.mode })
            .bind(to: output.runningMode)
            .disposed(by: disposeBag)
        
        return output
    }
}
