//
//  RunningPreparationViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxRelay
import RxSwift

final class RunningPreparationViewModel {
    private weak var coordinator: RunningSettingCoordinator?
    private let runningSettingUseCase: RunningSettingUseCase
    private let runningPreparationUseCase: RunningPreparationUseCase
    private let maxPreparationTime = 3
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    struct Output {
        var timeLeft = BehaviorRelay<String?>(value: "")
    }
    
    init(
        coordinator: RunningSettingCoordinator?,
        runningSettingUseCase: RunningSettingUseCase,
        runningPreparationUseCase: RunningPreparationUseCase
    ) {
        self.coordinator = coordinator
        self.runningPreparationUseCase = runningPreparationUseCase
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningPreparationUseCase.executeTimer()
            })
            .disposed(by: disposeBag)
        
        self.runningPreparationUseCase.timeLeft
            .map({ "\($0)" })
            .bind(to: output.timeLeft)
            .disposed(by: disposeBag)
        
        self.runningPreparationUseCase.isTimeOver
            .subscribe(onNext: { [weak self] isOver in
                self?.runningSettingUseCase.updateDateTime(date: Date())
                guard isOver, let settingData = try? self?.runningSettingUseCase.runningSetting.value() else {
                    return
                }
                self?.coordinator?.finish(with: settingData)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
