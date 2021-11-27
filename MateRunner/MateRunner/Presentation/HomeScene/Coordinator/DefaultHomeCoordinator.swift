//
//  DefaultHomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import UIKit

protocol InvitationRecievable: AnyObject {
    func invitationDidRecieve(invitation: Invitation)
    func invitationDidAccept(with settingData: RunningSetting)
    func invitationDidReject()
}

final class DefaultHomeCoordinator: HomeCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var homeViewController: HomeViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .home
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notiDidRecieve(_:)),
            name: Notification.Name("noti"),
            object: nil
        )
    }
    
    func start() {
        self.homeViewController.viewModel = HomeViewModel(
            coordinator: self,
            homeUseCase: DefaultHomeUseCase(locationService: DefaultLocationService())
        )
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func start(with settingData: RunningSetting) {
        let settingCoordinator = DefaultRunningSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        self.childCoordinators.append(settingCoordinator)
    }
    
    func showSettingFlow() {
        let settingCoordinator = DefaultRunningSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
    func showRunningFlow(with initialSettingData: RunningSetting) {
        let runningCoordinator = DefaultRunningCoordinator(self.navigationController)
        runningCoordinator.finishDelegate = self
        self.childCoordinators.append(runningCoordinator)
        runningCoordinator.pushRunningViewController(with: initialSettingData)
    }
    
    func startRunningFromNotification(with settingData: RunningSetting) {
        let settingCoordinator = DefaultRunningSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.pushRunningPreparationViewController(with: settingData)
    }
}

extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

extension DefaultHomeCoordinator: SettingCoordinatorDidFinishDelegate {
    func settingCoordinatorDidFinish(with runningSettingData: RunningSetting) {
        self.showRunningFlow(with: runningSettingData)
    }
}

extension DefaultHomeCoordinator: InvitationRecievable {
    func invitationDidAccept(with settingData: RunningSetting) {
        self.startRunningFromNotification(with: settingData)
        self.navigationController.tabBarController?.tabBar.isHidden = true
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

        self.navigationController.present(invitationViewController, animated: true)
    }
    
}
