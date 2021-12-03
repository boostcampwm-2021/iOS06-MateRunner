//
//  DefaultMyPageCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import UIKit

final class DefaultMyPageCoordinator: MyPageCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var myPageViewController: MyPageViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .mypage
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.myPageViewController = MyPageViewController()
    }
    
    func start() {
        self.myPageViewController.viewModel = MyPageViewModel(
            myPageCoordinator: self,
            myPageUseCase: DefaultMyPageUseCase(
                userRepository: DefaultUserRepository(
                    realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                ),
                firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(self.myPageViewController, animated: true)
    }
    
    func pushNotificationViewController() {
        let notificationViewController = NotificationViewController()
        notificationViewController.viewModel = NotificationViewModel(
            coordinator: self,
            notificationUseCase: DefaultNotificationUseCase(
                userRepository: DefaultUserRepository(
                    realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                ),
                firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                )
            )
        )
        notificationViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(notificationViewController, animated: true)
    }
    
    func pushProfileEditViewController(with nickname: String) {
        let profileEditViewController = ProfileEditViewController()
        profileEditViewController.hidesBottomBarWhenPushed = true
        profileEditViewController.viewModel = ProfileEditViewModel(
            coordinator: self,
            profileEditUseCase: DefaultProfileEditUseCase(
                firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                ),
                with: nickname
            )
        )
        self.navigationController.pushViewController(profileEditViewController, animated: true)
    }
    
    func pushLicenseViewController() {
        let licenseViewController = LicenseViewController()
        licenseViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(licenseViewController, animated: true)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }

    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultMyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
