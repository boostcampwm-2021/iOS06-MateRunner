//
//  DefaultNotificationCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import UIKit

final class DefaultNotificationCoordinator: NotificationCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .notification
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.pushNotificationViewController()
    }
    
    func pushNotificationViewController() {
        let notificationViewController = NotificationViewController()
        notificationViewController.viewModel = NotificationViewModel(
            notificationCoordinator: self,
            notificationUseCase: DefaultNotificationUseCase(
                userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(notificationViewController, animated: true)
    }
}
