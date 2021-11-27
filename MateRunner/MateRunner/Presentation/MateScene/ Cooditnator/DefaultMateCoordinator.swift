//
//  DefaultMateCoordinator.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/15.
//

import UIKit

final class DefaultMateCoordinator: MateCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var invitationDidAcceptDelegate: InvitationDidAcceptDelegate?
    var navigationController: UINavigationController
    var mateViewController: MateViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .mate
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mateViewController = MateViewController()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notiDidRecieve(_:)),
            name: Notification.Name("noti"),
            object: nil
        )
    }
    
    func start() {
        self.mateViewController.mateViewModel = MateViewModel(
            coordinator: self,
            mateUseCase: DefaultMateUseCase(
                mateRepository: DefaultMateRepository(
                    realtimeNetworkService: DefaultRealtimeDatabaseNetworkService(),
                    urlSessionNetworkService: DefaultURLSessionNetworkService()
                ), firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                ), userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(self.mateViewController, animated: true)
    }
    
    func showAddMateFlow() {
        let addMateCoordinator = DefaultAddMateCoordinator(self.navigationController)
        addMateCoordinator.finishDelegate = self
        self.childCoordinators.append(addMateCoordinator)
        addMateCoordinator.start()
    }
    
    func showMateProfileFlow(_ nickname: String) {
        let mateProfileCoordinator = DefaultMateProfileCoordinator(self.navigationController)
        mateProfileCoordinator.finishDelegate = self
        mateProfileCoordinator.user = nickname
        self.childCoordinators.append(mateProfileCoordinator)
        mateProfileCoordinator.start()
    }
}

extension DefaultMateCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}

extension DefaultMateCoordinator: InvitationRecievable {
    func invitationDidAccept(with settingData: RunningSetting) {
        self.invitationDidAcceptDelegate?.invitationDidAccept(with: settingData)
        self.navigationController.dismiss(animated: true)
    }
    
    func invitationDidReject() {
        self.navigationController.dismiss(animated: true)
    }
    
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
        invitationViewController.modalPresentationStyle = .overFullScreen
        invitationViewController.hidesBottomBarWhenPushed = true
        invitationViewController.view.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
        invitationViewController.view.isOpaque = false
        self.navigationController.viewControllers.last?.present(invitationViewController, animated: true)
    }
}
