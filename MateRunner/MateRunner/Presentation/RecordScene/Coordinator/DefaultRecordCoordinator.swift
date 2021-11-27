//
//  DefaultRecordCoordinator.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import UIKit

final class DefaultRecordCoordinator: RecordCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var invitationDidAcceptDelegate: InvitationDidAcceptDelegate?
    var navigationController: UINavigationController
    var recordViewController: RecordViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .record
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.recordViewController = RecordViewController()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notiDidRecieve(_:)),
            name: NotificationCenterKey.invitationDidRecieve,
            object: nil
        )
    }
    
    func start() {
        self.recordViewController.viewModel = RecordViewModel(
            coordinator: self,
            recordUsecase: DefaultRecordUseCase(
                userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(self.recordViewController, animated: true)
    }
    
    func push(with runningResult: RunningResult) {
        let recordDetailViewController = RecordDetailViewController()
        recordDetailViewController.viewModel = RecordDetailViewModel(
            recordDetailUseCase: DefaultRecordDetailUseCase(
                userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                ),
                with: runningResult
            )
        )
        self.navigationController.pushViewController(recordDetailViewController, animated: true)
    }
}

extension DefaultRecordCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {

    }
}

extension DefaultRecordCoordinator: InvitationRecievable {
    func invitationDidAccept(with settingData: RunningSetting) {
        self.invitationDidAcceptDelegate?.invitationDidAccept(with: settingData)
        self.navigationController.dismiss(animated: true)
    }
    
    func invitationDidReject() {
        self.navigationController.dismiss(animated: true)
    }
    
    @objc func notiDidRecieve(_ notification: Notification) {
        guard let invitation = notification.userInfo?[NotificationCenterKey.invitation] as? Invitation else { return }
        self.invitationDidRecieve(invitation: invitation)
    }
    
    func invitationDidRecieve(invitation: Invitation) {
        let useCase = DefaultInvitationUseCase(invitation: invitation)
        let viewModel = InvitationViewModel(coordinator: self, invitationUseCase: useCase)
        let invitationViewController = InvitationViewController()
        invitationViewController.viewModel = viewModel
        invitationViewController.modalPresentationStyle = .fullScreen
        invitationViewController.modalPresentationStyle = .overFullScreen
        invitationViewController.hidesBottomBarWhenPushed = true
        invitationViewController.view.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
        invitationViewController.view.isOpaque = false

        self.navigationController.present(invitationViewController, animated: true)
    }
}
