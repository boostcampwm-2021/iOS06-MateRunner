//
//  SceneDelegate.swift
//  MateRunner
//
//  Created by 이정원 on 2021/10/29.
//

import UIKit

import Firebase

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
        ImageCache.configureCachePolicy(with: 52428800)

        return
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
            if let nickname = UserDefaults.standard.string(forKey: UserDefaultKey.nickname) {
                Database.database().reference()
                    .child(RealtimeDatabaseKey.state)
                    .child(nickname)
                    .child(RealtimeDatabaseKey.isRunning)
                    .setValue(false)
            }
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
            invitationUseCase: DefaultInvitationUseCase(
                invitation: invitation,
                invitationRepository: DefaultInvitationRepository(
                    realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                )
            )
        )
        
        homeViewController.invitationViewController = invitationViewController
    }
}

