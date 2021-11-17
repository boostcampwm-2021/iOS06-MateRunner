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
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            self.showTabBarFlow()
        } else {
            self.showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = DefaultTabBarCoordinator(self.navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
    func showInvitationFlow(with invitation: Invitation) {
        guard let homeCoordinator = self.findCoordinator(type: .home) as? DefaultHomeCoordinator else { return }
        
        let settingCoordinator = self.findCoordinator(type: .setting) as? DefaultRunningSettingCoordinator ??
        DefaultRunningSettingCoordinator(homeCoordinator.navigationController)
        homeCoordinator.childCoordinators.append(settingCoordinator)
        settingCoordinator.finishDelegate = homeCoordinator
        settingCoordinator.settingFinishDelegate = homeCoordinator
        
        let useCase = DefaultInvitationUseCase(invitation: invitation)
        let viewModel = InvitationViewModel(settingCoordinator: settingCoordinator, invitationUseCase: useCase)
        let viewController = InvitationViewController(
            mate: invitation.host,
            mode: invitation.mode,
            distance: invitation.targetDistance
        )
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        
        settingCoordinator.navigationController.pushViewController(viewController, animated: false)
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        
        if childCoordinator.type == .login {
            self.navigationController.view.backgroundColor = .systemBackground
            self.navigationController.viewControllers.removeAll()
            self.showTabBarFlow()
        }
    }
}
