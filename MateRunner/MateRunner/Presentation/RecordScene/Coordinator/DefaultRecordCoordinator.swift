//
//  DefaultRecordCoordinator.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import UIKit

final class DefaultRecordCoordinator: RecordCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
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
            name: Notification.Name("noti"),
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
    @objc func notiDidRecieve(_ notification: Notification) {
        guard let invitation = notification.userInfo?["invitation"] as? Invitation else {return}
        self.invitationDidRecieve(invitation: invitation)
    }
    
    func invitationDidRecieve(invitation: Invitation) {
        let useCase = DefaultInvitationUseCase(invitation: invitation)
        let viewModel = InvitationViewModel(coordinator: self, invitationUseCase: useCase)
        let invitationViewController = InvitationViewController(
            mate: invitation.host,
            mode: invitation.mode,
            distance: invitation.targetDistance
        )
        invitationViewController.viewModel = viewModel
        invitationViewController.modalPresentationStyle = .fullScreen
        invitationViewController.modalPresentationStyle = .overCurrentContext
        invitationViewController.hidesBottomBarWhenPushed = true
        invitationViewController.view.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
        invitationViewController.view.isOpaque = false
        self.navigationController.viewControllers.last?.present(invitationViewController, animated: true)
    }
}
