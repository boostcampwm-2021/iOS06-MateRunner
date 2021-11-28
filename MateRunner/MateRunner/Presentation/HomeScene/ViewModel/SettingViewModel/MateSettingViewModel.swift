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
    
    func mateDidSelect(nickname: String) {
        self.runningSettingUseCase.updateMateNickname(nickname: nickname)
        self.runningSettingUseCase.mateIsRunning
            .map { !$0 }
            .subscribe(onNext: { [weak self] isSelectableMate in
                self?.isSelectableMate.accept(isSelectableMate)
                if isSelectableMate {
                    self?.pushDistanceSettingViewController()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func pushDistanceSettingViewController() {
        self.disposeBag = DisposeBag()
        self.coordinator?.pushDistanceSettingViewController(
            with: try? self.runningSettingUseCase.runningSetting.value()
        )
    }
}
