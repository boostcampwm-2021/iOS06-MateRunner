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
