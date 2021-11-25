//
//  DefaultMateProfileCoordinator.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import UIKit

final class DefaultMateProfileCoordinator: MateProfileCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .addMate }
    var user: String?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        self.pushMateProfileViewController()
    }
    
    func pushMateProfileViewController() {
        let mateProfileViewController = MateProfileViewController()
        mateProfileViewController.viewModel = MateProfileViewModel(
            nickname: self.user ?? "",
            coordinator: self,
            profileUseCase: DefaultProfileUseCase(
                fireStoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(mateProfileViewController, animated: true)
    }
}
