//
//  RunningModeViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/02.
//

import Foundation

import RxSwift
import RxRelay

final class MateRunningModeSettingViewModel {
    private weak var coordinator: SettingCoordinator?
    private let runningSettingUseCase: RunningSettingUseCase
    
    struct Input {
        let raceModeButtonDidTapEvent: Observable<Void>
        let teamModeButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var mode: BehaviorRelay<RunningMode> = BehaviorRelay<RunningMode>(value: .race)
        var moveToNext: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
    init(
        coordinator: SettingCoordinator,
        runningSettingUseCase: RunningSettingUseCase
    ) {
        self.coordinator = coordinator
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.raceModeButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.updateMode(mode: .race)
            })
            .disposed(by: disposeBag)
        
        input.teamModeButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.updateMode(mode: .team)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent
            .subscribe({ [weak self] _ in
                self?.coordinator?.pushDistanceSettingViewController(
                    with: try? self?.runningSettingUseCase.runningSetting.value()
                )
            })
            .disposed(by: disposeBag)
        
        self.runningSettingUseCase.runningSetting
            .compactMap({ runningSetting in
                runningSetting.mode
            })
            .bind(to: output.mode)
            .disposed(by: disposeBag)
        
        return output
    }
}
