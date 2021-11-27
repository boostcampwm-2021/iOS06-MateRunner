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
        
        if let notificationResponse = connectionOptions.notificationResponse {
            let userInfo = notificationResponse.notification.request.content.userInfo
            guard let invitation = Invitation(from: userInfo) else { return }
            NotificationCenter.default.post(
                name: Notification.Name("noti"),
                object: nil,
                userInfo: ["invitation": invitation]
            )
        }
        return
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

