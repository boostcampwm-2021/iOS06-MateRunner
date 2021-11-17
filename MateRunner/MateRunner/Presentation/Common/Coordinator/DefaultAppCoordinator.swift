//
//  AppCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//
//
import UIKit

final class DefaultAppCoordinator: AppCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        self.showTabBarFlow()
        // self.showLoginFlow()
    }
    
    func showLoginFlow() {
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = DefaultTabBarCoordinator(self.navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    func showInvitationFlow(with invitation: Invitation) {
        let settingCoordinator = DefaultRunningSettingCoordinator(self.navigationController)
        
        let useCase = DefaultInvitationUseCase(invitation: invitation)
        let viewModel = InvitationViewModel(settingCoordinator: settingCoordinator, invitationUseCase: useCase)
        let viewController = InvitationViewController(
            mate: invitation.host,
            mode: invitation.mode,
            distance: invitation.targetDistance
        )
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController.pushViewController(viewController, animated: false)
        
        childCoordinators.append(settingCoordinator)
    }
}
