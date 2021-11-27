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
    private weak var coordinator: InvitationRecievable?
    private let invitationUseCase: InvitationUseCase
    private let disposeBag = DisposeBag()

    init(coordinator: InvitationRecievable, invitationUseCase: InvitationUseCase) {
        self.coordinator = coordinator
        self.invitationUseCase = invitationUseCase
    }

    struct Input {
        let acceptButtonDidTapEvent: Observable<Void>
        let rejectButtonDidTapEvent: Observable<Void>
    }

    struct Output {
        var host: String
        var mode: String
        var targetDistance: String
        var cancelledAlertShouldShow: PublishRelay<Bool> = PublishRelay<Bool>()
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let invitation = self.invitationUseCase.invitation
        let output = Output(
            host: invitation.host,
            mode: "\(invitation.mode == .team ? "🤝": "🤜") \(invitation.mode.title)",
            targetDistance: invitation.targetDistance.totalDistanceString
        )
        
        input.acceptButtonDidTapEvent.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.invitationUseCase.checkIsCancelled()
                .filter { !$0 }
                .subscribe(onNext: { [weak self] _ in
                    self?.acceptInvitation()
                })
                .disposed(by: disposeBag)
        })
            .disposed(by: disposeBag)
        
        input.rejectButtonDidTapEvent.subscribe(onNext: { [weak self] in
            self?.invitationUseCase.rejectInvitation()
                .publish()
                .connect()
                .disposed(by: disposeBag)
            self?.finish()
        })
            .disposed(by: disposeBag)
        
        self.invitationUseCase.isCancelled
            .bind(to: output.cancelledAlertShouldShow)
            .disposed(by: disposeBag)

        return output
    }
    
    func finish() {
        self.coordinator?.invitationDidReject()
    }
    
    private func acceptInvitation() {
        self.invitationUseCase.acceptInvitation()
            .subscribe(onNext: { _ in
                self.coordinator?.invitationDidAccept(
                    with: self.invitationUseCase.invitation.toRunningSetting()
                )
            })
            .disposed(by: self.disposeBag)
    }
}
