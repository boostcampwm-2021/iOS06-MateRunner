//
//  MateSettingViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/11.
//

import Foundation

import RxRelay
import RxSwift

final class MateSettingViewModel {
    weak var coordinator: RunningSettingCoordinator?
    private let runningSettingUseCase: RunningSettingUseCase
    private var disposeBag = DisposeBag()
    
    init(
        coordinator: RunningSettingCoordinator?,
        runningSettingUseCase: RunningSettingUseCase
    ) {
        self.coordinator = coordinator
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var mateDidSelectEvent: Observable<String>
    }
    
    struct Output {
        var mateIsNowRunningAlertShouldShow: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
    func transform (input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningSettingUseCase.deleteMateNickname()
            })
            .disposed(by: disposeBag)
        
        input.mateDidSelectEvent
            .subscribe(onNext: { [weak self] nickname in
                self?.runningSettingUseCase.updateMateNickname(nickname: nickname)
            })
            .disposed(by: disposeBag)
        
        self.runningSettingUseCase.mateIsRunning
            .subscribe(onNext: { [weak self] isRunning in
                guard let self = self else { return }
                output.mateIsNowRunningAlertShouldShow.accept(isRunning)
                if !isRunning {
                    self.observeRunningSetting()
                }
            })
            .disposed(by: self.disposeBag)
        
        return output
    }
    
    private func observeRunningSetting() {
        self.runningSettingUseCase.runningSetting
            .filter({ $0.mateNickname != nil })
            .subscribe(onNext: { [weak self] runningSetting in
                self?.pushDistanceSettingViewController(with: runningSetting)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func pushDistanceSettingViewController(with runningSetting: RunningSetting) {
        self.disposeBag = DisposeBag()
        self.coordinator?.pushDistanceSettingViewController(
            with: runningSetting
        )
    }
}
