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
    }

    struct Output {
        var host: PublishRelay<String> = PublishRelay<String>()
        var mode: PublishRelay<RunningMode> = PublishRelay<RunningMode>()
        var targetDistance: PublishRelay<Double> = PublishRelay<Double>()
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

        return output
    }

    func acceptButtonDidTap() {
        self.invitationUseCase.acceptInvitation()
            .subscribe { success in
                if success.element ?? false {
                    self.settingCoordinator?.pushRunningPreparationViewController(
                        with: self.invitationUseCase.invitation.toRunningSetting()
                    )
                }
            }
            .disposed(by: self.disposeBag)
    }

    func rejectButtonDidTap() {
        self.invitationUseCase.rejectInvitation()
            .subscribe { success in
                if success.element ?? false {
                    self.settingCoordinator?.finish()
                }
            }
            .disposed(by: self.disposeBag)
    }
}
