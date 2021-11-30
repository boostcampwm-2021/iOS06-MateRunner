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
    var isSelectableMate = PublishRelay<Bool>()
    weak var coordinator: RunningSettingCoordinator?
    private let runningSettingUseCase: RunningSettingUseCase
    private var disposeBag = DisposeBag()
    
    init(
        coordinator: RunningSettingCoordinator,
        runningSettingUseCase: RunningSettingUseCase
    ) {
        self.coordinator = coordinator
        self.runningSettingUseCase = runningSettingUseCase
    }
    
    func initiateMate() {
        self.runningSettingUseCase.deleteMateNickname()
    }
    
    func mateDidSelect(nickname: String) {
        self.runningSettingUseCase.updateMateNickname(nickname: nickname)
        self.runningSettingUseCase.mateIsRunning
            .map { !$0 }
            .subscribe(onNext: { [weak self] isSelectableMate in
                guard let self = self else { return }
                self.isSelectableMate.accept(isSelectableMate)
                if isSelectableMate {
                    self.observeRunningSetting()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func observeRunningSetting() {
        self.runningSettingUseCase.runningSetting
            .subscribe(onNext: { [weak self] runningSetting in
                if runningSetting.mateNickname != nil {
                    self?.pushDistanceSettingViewController(with: runningSetting)
                }
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
