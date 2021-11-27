//
//  SceneDelegate.swift
//  MateRunner
//
//  Created by 이정원 on 2021/10/29.
//

import UIKit

enum NotificationCenterKey {
    static let invitationDidRecieve = Notification.Name("invitationDidRecieve")
    static let invitation = "invitation"
    static let sessionID = "sessionId"
    static let host = "host"
    static let mate = "mate"
    static let inviteTime = "inviteTime"
    static let mode = "mode"
    static let targetDistance = "targetDistance"
    static let sender = "sender"
}

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
        
        guard let notificationResponse = connectionOptions.notificationResponse else { return }
        let userInfo = notificationResponse.notification.request.content.userInfo
        self.configureInvitation(with: userInfo)

        return
    }
    
    private func configureInvitation(with userInfo: [AnyHashable: Any]) {
        guard let invitation = Invitation(from: userInfo),
              let tabBarCoordinator = self.appCoordinator?.findCoordinator(type: .tab) as? TabBarCoordinator,
              let homeCoordinator = self.appCoordinator?.findCoordinator(type: .home) as? DefaultHomeCoordinator,
              let lastChildViewController = homeCoordinator.navigationController.viewControllers.last ,
              let homeViewController = lastChildViewController as? HomeViewController else { return }
        
        let invitationViewController = InvitationViewController()
        invitationViewController.viewModel = InvitationViewModel(
            coordinator: tabBarCoordinator,
            invitationUseCase: DefaultInvitationUseCase(invitation: invitation)
        )
        
        homeViewController.invitationViewController = invitationViewController
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

