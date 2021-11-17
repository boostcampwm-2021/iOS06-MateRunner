//
//  InvitationWaitingViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/10.
//

import Foundation

import RxRelay
import RxSwift

final class InvitationWaitingViewModel {
    private weak var coordinator: RunningSettingCoordinator?
    private let invitationWaitingUseCase: InvitationWaitingUseCase
    
    init(coordinator: RunningSettingCoordinator, invitationWaitingUseCase: InvitationWaitingUseCase) {
        self.coordinator = coordinator
        self.invitationWaitingUseCase = invitationWaitingUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        var requestSuccess: PublishRelay<Bool> = PublishRelay<Bool>()
        var isRejected: PublishRelay<Bool> = PublishRelay<Bool>()
        var isCancelled: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
    func alertConfirmButtonDidTap() {
        self.coordinator?.finish()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.invitationWaitingUseCase.inviteMate()
            })
            .disposed(by: disposeBag)
        
        self.invitationWaitingUseCase.requestSuccess
            .bind(to: output.requestSuccess)
            .disposed(by: disposeBag)
        
        self.invitationWaitingUseCase.isAccepted
            .subscribe { [weak self] _ in
                guard let settingData = self?.invitationWaitingUseCase.runningSetting else { return }
                self?.coordinator?.pushRunningPreparationViewController(with: settingData)
            }.disposed(by: disposeBag)
        
        self.invitationWaitingUseCase.isRejected
            .bind(to: output.isRejected)
            .disposed(by: disposeBag)
        
        self.invitationWaitingUseCase.isCancelled
            .bind(to: output.isCancelled)
            .disposed(by: disposeBag)
        
        return output
    }
}
