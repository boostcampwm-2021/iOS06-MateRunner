//
//  DefaultMyPageCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import UIKit

final class DefaultMyPageCoordinator: MyPageCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var invitationDidAcceptDelegate: InvitationDidAcceptDelegate?
    var navigationController: UINavigationController
    var myPageViewController: MyPageViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .mypage
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.myPageViewController = MyPageViewController()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notiDidRecieve(_:)),
            name: Notification.Name("noti"),
            object: nil
        )
    }
    
    func start() {
        self.myPageViewController.viewModel = MyPageViewModel(
            myPageCoordinator: self,
            myPageUseCase: DefaultMyPageUseCase(
                userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                ),
                firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(self.myPageViewController, animated: true)
    }
    
    func showNotificationFlow() {
        let notificationCoordinator = DefaultNotificationCoordinator(self.navigationController)
        notificationCoordinator.finishDelegate = self
        self.childCoordinators.append(notificationCoordinator)
        notificationCoordinator.start()
    }
    
    func showProfileEditFlow(with nickname: String) {
        let profileEditCoordinator = DefaultProfileEditCoordinator(self.navigationController)
        profileEditCoordinator.finishDelegate = self
        self.childCoordinators.append(profileEditCoordinator)
        profileEditCoordinator.pushProfileEditViewController(with: nickname)
    }
    
    func showLicenseFlow() {
        let licenseCoordinator = DefaultLicenseCoordinator(self.navigationController)
        licenseCoordinator.finishDelegate = self
        self.childCoordinators.append(licenseCoordinator)
        licenseCoordinator.start()
    }
}

extension DefaultMyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

extension DefaultMyPageCoordinator: InvitationRecievable {
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
        invitationViewController.modalPresentationStyle = .overCurrentContext
        invitationViewController.hidesBottomBarWhenPushed = true
        invitationViewController.view.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
        invitationViewController.view.isOpaque = false
        self.navigationController.viewControllers.last?.present(invitationViewController, animated: true)
    }
}
