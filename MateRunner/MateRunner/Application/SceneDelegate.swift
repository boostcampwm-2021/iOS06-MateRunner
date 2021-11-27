//
//  SceneDelegate.swift
//  MateRunner
//
//  Created by 이정원 on 2021/10/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.tintColor = .mrPurple
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        self.appCoordinator = DefaultAppCoordinator(navigationController)
        self.appCoordinator?.start()
        configureInvitation(connectionOptions: connectionOptions)
        
        return
    }
    
    private func configureInvitation(connectionOptions: UIScene.ConnectionOptions) {
        guard let notificationResponse = connectionOptions.notificationResponse else { return }
        let userInfo = notificationResponse.notification.request.content.userInfo
        
        guard let invitation = Invitation(from: userInfo),
              let homeCoordinator = self.appCoordinator?.findCoordinator(type: .home) as? DefaultHomeCoordinator,
              let lastChildViewController = homeCoordinator.navigationController.viewControllers.last ,
              let homeViewController = lastChildViewController as? HomeViewController else { return }
        
        let invitationViewController = InvitationViewController(
            mate: invitation.host,
            mode: invitation.mode,
            distance: invitation.targetDistance
        )
        
        invitationViewController.viewModel = InvitationViewModel(
            coordinator: homeCoordinator,
            invitationUseCase: DefaultInvitationUseCase(invitation: invitation)
        )
        
        homeViewController.invitationViewController = invitationViewController
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

