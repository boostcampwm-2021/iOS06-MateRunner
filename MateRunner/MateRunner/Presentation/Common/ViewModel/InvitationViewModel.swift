//
//  InvitationViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/15.
//

import Foundation

import RxRelay
import RxSwift

final class InvitationViewModel {
    private weak var settingCoordinator: RunningSettingCoordinator?
    private let invitationUseCase: InvitationUseCase
    private let disposeBag = DisposeBag()

    init(settingCoordinator: RunningSettingCoordinator, invitationUseCase: InvitationUseCase) {
        self.settingCoordinator = settingCoordinator
        self.invitationUseCase = invitationUseCase
    }

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let acceptButtonDidTapEvent: Observable<Void>
        let rejectButtonDidTapEvent: Observable<Void>
    }

    struct Output {
        var host: PublishRelay<String> = PublishRelay<String>()
        var mode: PublishRelay<RunningMode> = PublishRelay<RunningMode>()
        var targetDistance: PublishRelay<Double> = PublishRelay<Double>()
        var cancelledAlertShouldShow: PublishRelay<Bool> = PublishRelay<Bool>()
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        let invitation = input.viewDidLoadEvent.map { self.invitationUseCase.invitation }

        invitation.map { $0.host }
        .bind(to: output.host)
        .disposed(by: disposeBag)

        invitation.map { $0.mode }
        .bind(to: output.mode)
        .disposed(by: disposeBag)

        invitation.map { $0.targetDistance }
        .bind(to: output.targetDistance)
        .disposed(by: disposeBag)
        
        input.acceptButtonDidTapEvent.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.invitationUseCase.checkIsCancelled().subscribe(onNext: { isCancelled in
                if !isCancelled {
                    self.acceptInvitation()
                }
            }).disposed(by: disposeBag)
        })
            .disposed(by: disposeBag)
        
        input.rejectButtonDidTapEvent.subscribe(onNext: { [weak self] in
            self?.finish()
        })
            .disposed(by: disposeBag)
        
        self.invitationUseCase.isCancelled
            .bind(to: output.cancelledAlertShouldShow)
            .disposed(by: disposeBag)

        return output
    }
    
    func finish() {
        self.settingCoordinator?.finish()
    }
    
    private func acceptInvitation() {
        self.invitationUseCase.acceptInvitation()
            .subscribe(onNext: { _ in
                self.settingCoordinator?.pushRunningPreparationViewController(
                    with: self.invitationUseCase.invitation.toRunningSetting()
                )
            })
            .disposed(by: self.disposeBag)
    }
}
